class_name BuildingMenu
extends HBoxContainer

@export var removal_restore_factor:float = 0.67

@onready var display_container: PanelContainer = $"../../DisplayContainer"
@onready var work_button: TextureButton = $PanelContainer/VBoxContainer/HBoxContainer/WorkContainer/WorkButton
@onready var research_button: TextureButton = $PanelContainer/VBoxContainer/HBoxContainer/ResearchContainer/ResearchButton
const BLUNT_TOOLS = preload("res://3rd Party/assets/icons/blunt_tools.png")

var building: BuildingBase

func _ready() -> void:
	research_button.pressed.connect(_research_button_clicked)
	work_button.pressed.connect(_work_button_clicked)
	work_button.texture_normal = Globals.resize_texture(64, BLUNT_TOOLS)

func _research_button_clicked():
	building.update_tech()
	display_container.close()
	display_container.set_item(building.research_ui)

func _work_button_clicked():
	building.update_jobs()
	display_container.close()
	display_container.set_item(building.work_ui)

func _on_remove_building_button_pressed() -> void:
	var building_res = BuildingManager.get_resource_from_building_type(building.type)
	for building_requirement:material_stack in building_res.requirements:
		var amount = ceil( removal_restore_factor * building_requirement.material_amount)
		InventoryManager.add_material(building_requirement.material_type,amount)
	Globals.delete_selected_building.emit()
	self.visible = false
