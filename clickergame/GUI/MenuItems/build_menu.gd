class_name BuildMenu
extends HBoxContainer

signal build_button_clicked

func _ready() -> void:
	GameEvents.building_unlocked.connect(_on_building_unlocked)
	GameEvents.empty_tile_selected.connect(toggleBuildMenu)
var BUILD_BUILDING_BUTTON = preload("res://GUI/MenuItems/build_building_button.tscn")

var has_buttons = false
func _on_building_unlocked(building_type: BuildingManager.building_types):
	get_parent().show()
	var building_button: BuildBuildingButton = BUILD_BUILDING_BUTTON.instantiate()
	building_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	building_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(building_button)
	building_button.name = Utilities.get_name_from_type(building_type, BuildingManager.building_types)
	building_button.visible = false
	building_button.pressed.connect(_on_button_pressed)
	building_button.buildingtype = building_type
	building_button.update_building_info(building_type)
	has_buttons = true

func _on_building_built(_build_type):
	toggleBuildMenu(null, false)

@warning_ignore("shadowed_variable_base_class")
func toggleBuildMenu(_location = null, visible = true):
	var vis = visible
	self.visible = vis
	get_parent().visible = vis
	for kid in get_children():
		kid.visible = vis

func _on_button_pressed(button, type: BuildingManager.building_types = BuildingManager.building_types.UNDEFINED) -> void:
	var has_all = true
	for requirement in BuildingManager.get_resource_from_building_type(type).requirements:
		if !InventoryManager.has_material_stack(requirement):
			has_all = false
			var missing_material = Utilities.get_name_from_type(requirement.material_type, InventoryManager.material_types)
			button.animate_missing_resource(missing_material)
	if has_all:
		BuildingManager.build(type)
		_on_building_built(type)
