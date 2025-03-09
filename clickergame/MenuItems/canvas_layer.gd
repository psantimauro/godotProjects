class_name GameHUD
extends CanvasLayer

@onready var action_container: Container = $ActionContainer
@onready var items_container: PanelContainer = $ItemsContainer
@onready var display_container: PanelContainer = $DisplayContainer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("close"):
		close_action_container()
		close_display_container()

func close_action_container():
	Globals.clear_selection.emit()
	action_container.hide_kids()
	action_container

func close_display_container():
	display_container.close()
