extends ProgressBar

@export var speed = 2
@onready var timer = $Timer
@onready var sound = $AudioStreamPlayer2D
signal done

func _ready() -> void:
	show_percentage = false
func _process(_delta: float) -> void:
	value = (timer.wait_time -timer.time_left)/timer.wait_time *100


func _on_timer_timeout() -> void:
	timer.stop()
	done.emit()
	sound.stop()

func start():
	if timer.is_stopped():
		timer.wait_time = speed
		value = 0
		timer.start()
		sound.play()
