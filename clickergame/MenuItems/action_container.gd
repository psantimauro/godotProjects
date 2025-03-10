class_name ActionContainer
extends PanelContainer

@onready var build_menu: BuildMenu = $BuildMenu
@onready var building_menu: HBoxContainer = $BuildingMenu

func _ready() -> void:
	Globals.clear_selection.connect(hide_kids)
	
	#Globals.connect("empty_tile_selected",toggleBuildMenu)
	
func hide_kids():
	for child:Control in get_children(false):
		if child:
			child.visible = false
