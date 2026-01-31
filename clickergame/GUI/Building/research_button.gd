class_name ResearchButton
extends Button

@export var tech: base_tech_resource
@onready var button: Button = $Button

func _ready() -> void:
	await button
	button.text = tech.description
	var unlock_job_tech: job_unlock_tech = tech
	if unlock_job_tech != null:
			var new_description =  tech.description
			for item: material_stack in unlock_job_tech.research_cost:
				var words = "Costs " + InventoryManager.material_types.keys()[item.material_type] + " " + item.material_amount
				new_description  = new_description +"\n"+words
			button.text = new_description
