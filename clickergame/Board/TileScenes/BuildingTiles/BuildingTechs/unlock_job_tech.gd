class_name UnlockJobTech
extends Node

@export var tech_resource: job_unlock_tech 
var timer: ClickableProgressBar 
func _ready() -> void:
	if tech_resource != null:
		self.name = "Research " + tech_resource.unlocked_job.resource_name
		timer.done.connect(_on_timer_timeout)
		add_child(timer)

func start_research() -> void:
	if remove_requirement_from_inventory():
		stop_research()
		timer.show()
		timer.timer_duration = tech_resource.research_speed
		timer.start()
	else:
		#inform the player they cant do the thing
		pass

func stop_research():
	timer.hide()
	timer.stop()
	
func _on_timer_timeout() -> void:
	var type = timer.get_parent().type #hack to get the type
	BuildingManager.unlock_job_by_tech(tech_resource, type)

func remove_requirement_from_inventory() -> bool:
	var status = false
	if tech_resource != null:
		status = true
		for requirement:material_stack in tech_resource.research_cost:
			if InventoryManager.has_material_stack(requirement):
				InventoryManager.remove_material(requirement.material_type, requirement.material_amount)
			else:
				status = false
	return status
