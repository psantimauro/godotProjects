class_name BuildMenu
extends VFlowContainer

signal build_button_clicked

func _ready() -> void:
	InventoryManager.building_built.connect(_on_building_built)
	InventoryManager.building_unlocked.connect(_on_building_unlocked)
	GlobalSignals.connect("empty_tile_selected",toggleBuildMenu)

func _on_building_unlocked(building_type: InventoryManager.building_types):
	var building_button:BuildingButton = BuildingButton.new()
	var building_res:building_resource = InventoryManager.get_resource_from_building_type(building_type)
	
	building_button.set_texture(building_res.texture)
	building_button.set_type(building_type)
	building_button.name = building_res.res_name
	building_button.visible = false
	building_button.pressed.connect(_on_button_pressed)
	add_child(building_button)

func _on_building_built(_build_type):
	toggleBuildMenu(null, false)

func toggleBuildMenu(_location = null, visible = true):
	var vis = visible
	self.visible = vis
	for kid in get_children():
		kid.visible = vis

func _on_button_pressed(type) -> void:
	build_button_clicked.emit(type) #0 is the type for tent
