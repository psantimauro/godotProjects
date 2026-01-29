class_name GameHUD
extends CanvasLayer

@onready var action_container: Container = $ActionContainer
@onready var items_container: PanelContainer = $ItemsContainer
@onready var display_container: PanelContainer = $DisplayContainer
@export var game_menu: Container

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("close"):
		if display_container.visible or action_container.visible:
			close_action_container()
			close_display_container()
		else:
			pass
			#show menu

func close_action_container():
	Globals.clear_selection.emit()
	action_container.hide_kids()
	action_container

func close_display_container():
	display_container.close()
