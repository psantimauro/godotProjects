class_name ActionContainer

extends PanelContainer
@onready var build_menu: BuildMenu = $BuildMenu
@onready var building_menu: HBoxContainer = $BuildingMenu

func _ready() -> void:
	Globals.clear_selection.connect(hide_kids)
func hide_kids():
	for child:Control in get_children(true):
		if child:
			child.visible = false
