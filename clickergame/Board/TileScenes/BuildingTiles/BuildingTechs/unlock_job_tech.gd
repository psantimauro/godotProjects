class_name UnlockJobTech
extends Node

@export var tech_resource: job_unlock_tech 
var timer: TimerProgressBar 
func _ready() -> void:
	if tech_resource != null:
		#var type_name = str(InventoryManager.material_types.keys()[job_resource.job_result.material_type]).to_lower()
		self.name = "Research " + tech_resource.unlocked_job.resource_name
		
		timer.done.connect(_on_timer_timeout)
		add_child(timer)
	
func start_research() -> void:
	if remove_requirement_from_inventory():
		stop_research()
		timer.timer_duration = tech_resource.research_speed
		timer.start()
	else:
		#inform the player they cant do the thing
		pass

func stop_research():
	timer.stop()
	
func _on_timer_timeout() -> void:
	BuildingManager.unlock_job(tech_resource)
	timer.stop() #research only runs once

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
