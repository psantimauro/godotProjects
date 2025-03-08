class_name BuildMenu
extends VFlowContainer

signal build_button_clicked

func _ready() -> void:
	BuildingManager.building_built.connect(_on_building_built)
	BuildingManager.building_unlocked.connect(_on_building_unlocked)
	Globals.connect("empty_tile_selected",toggleBuildMenu)

func _on_building_unlocked(building_type: BuildingManager.building_types):
	var building_button:BuildBuildingButton = BuildBuildingButton.new()
	add_child(building_button)
	building_button.update_building_info(building_type)
	building_button.visible = false
	building_button.pressed.connect(_on_button_pressed)
	building_button.buildingtype = building_type

func _on_building_built(_build_type):
	toggleBuildMenu(null, false)

func toggleBuildMenu(_location = null, visible = true):
	var vis = visible
	self.visible = vis
	for kid in get_children():
		kid.visible = vis

func _on_button_pressed(type) -> void:
	BuildingManager.build(type)
