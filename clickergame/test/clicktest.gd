extends Node2D

@onready var clickable_timer_progress_bar: Node2D = $VBoxContainer/ClickableTimerProgressBar

func _ready() -> void:
	
	clickable_timer_progress_bar.start()
	#clickable_timer_progress_bar.show_percentage = true
	clickable_timer_progress_bar.texture = preload("res://3rd Party/assets/gui/grey_boxCross.png")
	
func _on_button_pressed() -> void:
	clickable_timer_progress_bar.start()

func _on__pressed_2() -> void:
	clickable_timer_progress_bar.click(5)


func _on__pressed_3() -> void:
		clickable_timer_progress_bar.click(-2.5)
