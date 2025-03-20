class_name  ClickableProgressBar
extends Control

@onready var timer: Timer = %Timer
@onready var progress_bar: ProgressBar = $ProgressBar
@export var run_time: float = 5.0  # Total time for the progress bar to fill
@export var one_shot:bool = false:
	set(val):
		one_shot= val
		timer.one_shot = val
@onready var button: Button = $Button

signal done

func _ready() -> void:
	await timer.ready
	timer.timeout.connect(_on_timer_timeout)

func _process(_delta: float) -> void:
	if timer.time_left > 0:
		progress_bar.value = (1 - (timer.time_left / run_time)) * 100

func start():
	if timer.is_stopped():
		timer.wait_time = run_time
		progress_bar.value = 0
		progress_bar.show()
		button.text = ""
		timer.start()
	
func is_stopped() -> bool:
	return timer.is_stopped() && progress_bar.value == 0

func stop():
	timer.stop()
	progress_bar.value = 0
	progress_bar.hide()

func _on_timer_timeout():
	done.emit()
	progress_bar.value = 0
	progress_bar.hide()
	button.text = "no Click"
	
func click(amount):
	_speed_up_timer(amount)

func _speed_up_timer(amount: float):
	if !timer.is_stopped():
		var new_time =timer.time_left - amount
		new_time = min(new_time,run_time)
		if new_time > 0.0001:
			timer.wait_time = new_time
			progress_bar.show()
			button.text = ""
			timer.stop()
			timer.start(new_time)
		else:
			stop()
			_on_timer_timeout()
	else:
		start()

func _on_button_pressed() -> void:
	if !timer.is_stopped():
		_speed_up_timer(0.1)
	else:
		start()
