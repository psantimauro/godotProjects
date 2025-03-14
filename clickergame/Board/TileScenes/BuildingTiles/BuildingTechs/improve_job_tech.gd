class_name ImproveJobTech
extends Node

@export var tech_resource: job_improve_tech 
var timer: TimerProgressBar 
func _ready() -> void:
	if tech_resource != null:
		self.name = "Improve " + tech_resource.improve_job.res_name + " Job"
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
	var building_type = timer.get_parent().type #hack to get the building type
	var job_to_improve = tech_resource.improve_job
	var grandparent = self.get_parent().get_parent()
	BuildingManager.improve_job_by_building_type(building_type, job_to_improve, tech_resource.improve_amount)
	#TODO improve the job


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
