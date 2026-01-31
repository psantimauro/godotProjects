class_name BuildingBase
extends Node2D

@export var group_type: TileManager.tile_types = TileManager.tile_types.BUILDING
@export var type: BuildingManager.building_types = BuildingManager.building_types.UNDEFINED
@export var building_power = 1
@export var button_size = 75
@export var removal_restore_factor: float = 0.67
signal selected

@export var clickable_timer_progress_bar: ClickableProgressBar

func _ready() -> void:
	add_to_group(Utilities.get_name_from_type(group_type, TileManager.tile_types))


func click(power = building_power):
	assist_building(power)
	GameEvents.building_selected.emit(self)


func assist_building(power):
	if !clickable_timer_progress_bar.is_stopped():
		clickable_timer_progress_bar.click(power)
func active() -> bool:
	return false

func generate_building_action_menu():
	var building_menu = HBoxContainer.new()

	building_menu.add_child(delete_button())
	return building_menu
	
func delete_button() -> Container:
	var button_container = VBoxContainer.new()
	var delete_lamba = func():
		var building_res = BuildingManager.get_resource_from_building_type(type)
		for building_requirement: material_stack in building_res.requirements:
			var amount = ceil(removal_restore_factor * building_requirement.material_amount)
			InventoryManager.add_material(building_requirement.material_type, amount)
		GameEvents.delete_selected_building.emit()
		self.queue_free()


	var new_label = Label.new()
	new_label.text = "Teardown"
	button_container.add_child(new_label)
		
	var new_btn = TextureButton.new()
	new_btn.name = "DeleteButton"
	new_btn.texture_normal = Utilities.resize_texture(button_size, preload("res://3rd Party/assets/icons/card_outline_remove.png"))
	new_btn.pressed.connect(delete_lamba)
	button_container.add_child(new_btn)
	
	return button_container
