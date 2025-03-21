extends Node2D
const CLICKABLE_TIMER_PROGRESS_BAR = preload("res://clickable_timer_progress_bar.tscn")
@onready var button: Button = %Button
@onready var button_container: GridContainer = $VBoxContainer
@onready var _0: ClickableProgressBar = $"VBoxContainer/0"


func _ready() -> void:
	_0.done.connect(_on_0_button_pressed)
	NumberManager.new_button_unlocked.connect(make_new_button)
	NumberManager.presto_enable.connect(enable_presto)
	NumberManager.next_cost_change.connect(update_cost_next)
	NumberManager.growth_rate_change.connect(update_growth_rate)
	NumberManager.expontent_change.connect(update_expontent)
	NumberManager.number_change.connect(update_number)
	
func update_number(number):
	%Value.text = str(int(number))

func update_expontent(expontent):
	%Exponent.text = "Exponent: "+ str(expontent)

func update_growth_rate(growth_rate = 0):
	%growth_factor.text = "Growth Factor: %.3f " % (growth_rate)
	
func update_cost_next ( next = 0):
	%Cost.text = "Next Cost: " + str(int(next))
func _on_0_button_pressed():
	NumberManager.increase_numer()
	if _0.is_stopped():
		_0.run_time = NumberManager.button_runtime()	
		_0.start()
func _on_button_pressed() -> void:
	if !_0.visible:
		_0.show()
	NumberManager.increase_numer()

var btn_num=1
func make_new_button():
	var btn = CLICKABLE_TIMER_PROGRESS_BAR.instantiate()
	button_container.add_child(btn)
	btn.one_shot = true
	btn.run_time = NumberManager.button_runtime()
	btn.name =  str(btn_num)
	btn_num +=1
	btn.done.connect( func(): 
		var num = int(btn.name)
		var val = NumberManager.get_button_value(num)
		NumberManager.increase_numer(val)
		num -= 1
		if num == -1:
			button.emit_signal("pressed")
		else:
			var Prev_button = button_container.get_node(str(num))
			if Prev_button.is_stopped():
				Prev_button.run_time = NumberManager.button_runtime()		
				Prev_button.start()
			else:
				Prev_button.click(val)
	)

func _on_presto_pressed() -> void:
	NumberManager.presto +=1
	%PrestoBar.value += 1
	if %PrestoBar.value == 10 :
		presti()
		
func enable_presto():
	%PrestoButton.show()
	%PrestoBar.show()

func presti():
	btn_num = 1
	%PrestoBar.set_value_no_signal(0)
	_0.stop()
	%PrestoButton.hide()
	%PrestoBar.hide()
	NumberManager.presti_reset()
	for child in button_container.get_children():
		var number = int(child.name)
		if number > 0:
			child.queue_free()
