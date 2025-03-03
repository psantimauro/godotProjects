class_name TimerProgressBar
extends ProgressBar

@export var timer_duration = 2
@export var power_multipler = 1.0

@onready var timer:Timer = $Timer

@onready var sprite = $Sprite2D
@export var texture: Texture:
	set(val):
		var image = val.get_image()
		image.resize(50,50)
		texture = ImageTexture.new().create_from_image(image)
		sprite.texture =texture
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var audio_stream: AudioStream:
	set(val):
		audio_stream = val
		audio_stream_player_2d.stream= val
signal done

func _ready() -> void:
	if audio_stream != null:
		audio_stream_player_2d.stream = audio_stream
	show_percentage = false
	
func _process(_delta: float) -> void:
	value = (timer.wait_time - (timer.time_left ))/timer.wait_time *100


func _on_timer_timeout() -> void:
	visible = false
	timer.stop()
	done.emit()
	audio_stream_player_2d.stop()
func stop():
	timer.stop()
func start():
	self.visible = true
	if timer.is_stopped():
		timer.wait_time = timer_duration/power_multipler
		value = 0
		timer.start()
		audio_stream_player_2d.play()
