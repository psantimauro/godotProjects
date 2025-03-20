extends Node2D
const CLICKABLE_TIMER_PROGRESS_BAR = preload("res://clickable_timer_progress_bar.tscn")
@onready var button: Button = %Button
@onready var button_container: GridContainer = $VBoxContainer
@onready var _0: ClickableProgressBar = $"VBoxContainer/0"
var presto = 0
var growth_rate = 1.07:
	set(g):
		growth_rate = g
		%growth_factor.text = "Growth Factor: "+ str(growth_rate)
var cost_base = 4

var expontent = 0:
	set(e):
		expontent = e
		%Exponent.text = "Exponent: "+ str(e)
var number = 0:
	set(n):
		number = n
		%Value.text = str(int(number))

var time_factor = 5
func _ready() -> void:
	_0.done.connect(_on_0_button_pressed)
	
func _process(delta: float) -> void:
	var cost_next = cost_base * pow(growth_rate ,expontent)
	if cost_next < number: 
		make_new_button()
		expontent += 1
		cost_base = cost_next
		growth_rate += 0.01
		number -= cost_next
	%Cost.text = "Next Cost: " + str(int(cost_next))
	if expontent >= 9 && !%PrestoButton.visible:
		enable_presto()
func _on_0_button_pressed():
	increase_numer()
	if _0.is_stopped():
		_0.run_time = max(time_factor / growth_rate, 0.1)			
		_0.start()
func _on_button_pressed() -> void:
	if !_0.visible:
		_0.show()
	increase_numer()

func increase_numer(num  = 1):
	number += num
	time_factor -= (0.001 * presto)

func make_new_button():
	var btn = CLICKABLE_TIMER_PROGRESS_BAR.instantiate()
	button_container.add_child(btn)
	btn.one_shot = true
	btn.run_time = 5*expontent
	btn.name =  str(expontent )
	btn.done.connect( func(): 
		var num = int(btn.name)
		var val = int(num / growth_rate)+1
		increase_numer(val)
		num -= 1
		if num == -1:
			button.emit_signal("pressed")
		
		else:
			var but = button_container.get_node(str(num))
			if but.is_stopped():
				but.run_time = max(time_factor / growth_rate, 0.1)			
				but.start()
			else:
				but.click(val)
	)

	
func _on_presto_pressed() -> void:
	presto += 1
	%PrestoBar.value = presto
	if %PrestoBar.value > 10:
		presti()
func enable_presto():
	%PrestoButton.show()
	%PrestoBar.show()

func presti():
	%PrestoButton.hide()
	%PrestoBar.hide()
	time_factor = 5
	expontent= 0
	number = 0
	for child in button_container.get_children():
		var number = int(child.name)
		if number > 0:
			child.queue_free()
