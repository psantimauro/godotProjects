class_name BuildingResearch
extends Control

@onready var research_buttons_container: VBoxContainer = $ResearchContainer
@onready var building: BuildingBase = $"../.."

@export var button_texture: Texture
var button_group: ButtonGroup = ButtonGroup.new()

func _on_button_pressed(tech) -> void:
	building.start_research(tech)
	GameEvents.clear_selection.emit()

func add_research(tech):
	add_research_button(tech)

func add_research_button(research_tech: base_tech_resource):
	if research_tech != null:
		var button_name = research_tech.resource_name
		var new_button = Button.new()
		new_button.text = button_name
		new_button.name = button_name + "Button"
		new_button.toggle_mode = true
		new_button.button_group = button_group
		new_button.pressed.connect(_on_button_pressed.bind(research_tech))
		research_buttons_container.add_child(new_button)
			
		var new_description = research_tech.description
		for item: material_stack in research_tech.research_cost:
			#var words = "Costs " + str(item.material_amount) + " " + InventoryManager.material_types.keys()[item.material_type]
			new_description = new_description
			new_button.text = new_description

func clear():
	for item in research_buttons_container.get_children():
		item.queue_free()
