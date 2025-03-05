class_name BuildingMenu
extends HBoxContainer

@export var removal_restore_factor:float = 0.67

@onready var work_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/Panel/WorkContainer/Button
@onready var research_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/ResearchContainer/Button
@onready var display_container: PanelContainer = $"../../DisplayContainer"

func _ready() -> void:
	research_button.pressed.connect(_research_button_clicked)
	work_button.pressed.connect(_work_button_clicked)
	
var building: BuildingBase

func _research_button_clicked():
	building.update()
	display_container.set_item(building.research)

func _work_button_clicked():
	building.update()
	display_container.set_item(building.work)


func _on_remove_building_button_pressed() -> void:
	var building_res = InventoryManager.get_resource_from_building_type(building.type)
	for building_requirement:material_stack in building_res.requirements:
		var amount = ceil( removal_restore_factor * building_requirement.material_amount)
		InventoryManager.add_material(building_requirement.material_type,amount)
	Globals.delete_selected_building.emit()
	self.visible = false
