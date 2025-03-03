class_name ActionContainer

extends PanelContainer
@onready var build_menu: BuildMenu = $BuildMenu
@onready var building_menu: HBoxContainer = $BuildingMenu

func hide_kids():
	for child:Control in get_children():
		if child:
			child.visible = false
