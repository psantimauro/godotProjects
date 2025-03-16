class_name  ClickableProgressBar
extends Node2D

@export var run_time: float = 5.0  # Total time for the progress bar to fill
@export var power_factor = 1.0
@export var one_shoot:bool = false:
	set(val):
		one_shoot= val
		timer.one_shot = val
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var texture: Texture:
	set(val):
		val = Globals.resize_texture(50, val)
		if sprite_2d:
			sprite_2d.texture = val
		texture=val

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var sound: AudioStream:
	set(val):
		if audio_stream_player_2d:
			audio_stream_player_2d.stream = val
		sound = val

@onready var timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $ProgressBar

signal done

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)


func start():
	if timer.is_stopped():
		timer.wait_time = run_time
		progress_bar.value = 0
		progress_bar.show()
		timer.start()
	
func is_stopped() -> bool:
	return timer.is_stopped() && progress_bar.value == 0
func stop():
	timer.stop()
	progress_bar.value = 0
	progress_bar.hide()
	
func _process(_delta: float) -> void:
	if timer.time_left > 0:
		progress_bar.value = (1 - (timer.time_left / run_time)) * 100

func _on_timer_timeout():
	audio_stream_player_2d.play()
	done.emit()
	progress_bar.value = 0
	
func click(amount):
	_speed_up_timer(amount)

func _speed_up_timer(amount: float):
	if !timer.is_stopped():
		var new_time =timer.time_left - amount*power_factor
		new_time = min(new_time,run_time)
		if new_time > 0:
			timer.stop()
			timer.start(new_time)
		else:
			timer.stop()
			_on_timer_timeout()
