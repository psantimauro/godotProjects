class_name BuildingResearch
extends Control

@onready var research_buttons_container: GridContainer = $VBoxContainer/ResearchButtonsContainer
@onready var progress_bar: TimerProgressBar = $"../ProgressBar"

@onready var building: BuildingBase = $".."

var button_group: ButtonGroup = ButtonGroup.new()

func _on_button_pressed(tech = BuildingManager.TENT_CREATE_MEAT) -> void:
	building.start_research(tech)
	Globals.clear_selection.emit()

func add_research(tech):
	add_research_button(tech)

func add_research_button(research_tech:base_tech_resource = BuildingManager.TENT_CREATE_MEAT):
	if research_tech != null:
		var button_name = "Research" + research_tech.resource_name
		var button_exists = false
	
		for item in research_buttons_container.get_children():
			if (item is Button) and item.name == button_name:
				button_exists = true
		
		if !button_exists:
			var new_button= Button.new()
			new_button.text =  button_name
			new_button.name = button_name
			
			var unlock_job_tech: job_unlock_tech = research_tech
			if unlock_job_tech != null:
				var new_description =  research_tech.description
				for item: material_stack in unlock_job_tech.research_cost:
					var words = "Costs "  + str(item.material_amount)  + " " + InventoryManager.material_types.keys()[item.material_type]
					new_description  = new_description +"\n"+words
				new_button.text = new_description
			
			new_button.toggle_mode = true
			new_button.button_group = button_group
			new_button.pressed.connect(_on_button_pressed.bind(research_tech))
			research_buttons_container.add_child(new_button)
