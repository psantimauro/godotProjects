extends Node2D

signal clicked

@export var click_delay = 2
@export var restart = true
@export var _auto_start = true

@onready var marker_2d: Marker2D = $Marker2D
@onready var icon: Sprite2D = $Icon
@onready var click_delay_timer: Timer = $ClickDelayTimer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
#	await  click_delay_timer.ready
	click_delay_timer.wait_time = click_delay 
	click_delay_timer.timeout.connect(_on_click_delay_timer_timeout)	
	if _auto_start == true:
		click_delay_timer.start()
func click():
	clicked.emit(marker_2d.position)
	var tween = get_tree().create_tween()
	tween.tween_property(icon, "scale", Vector2.ONE /2, 0.25)
	audio_stream_player_2d.play()
	tween.tween_property(icon, "scale", Vector2.ONE , 0.25)
	
func _on_click_delay_timer_timeout():
	click()
	click_delay_timer.wait_time = click_delay 
	if restart == true:
		click_delay_timer.start()
