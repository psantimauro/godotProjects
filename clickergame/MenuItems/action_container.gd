class_name ActionContainer
extends PanelContainer

@onready var build_menu: BuildMenu = $BuildMenu

func _ready() -> void:
	Globals.clear_selection.connect(hide_kids)

	
func hide_kids():
	if dynamic_menu != null:
		dynamic_menu.queue_free()
	for child:Control in get_children(false):
		if child:
			child.visible = false

var dynamic_menu = null
func display_building_menu(container):
	if dynamic_menu != null:
		dynamic_menu.queue_free()
	self.show()
	self.add_child(container)
	dynamic_menu = container
