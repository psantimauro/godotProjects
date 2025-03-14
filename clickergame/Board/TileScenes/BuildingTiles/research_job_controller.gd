class_name BuildingResearchController
extends Node

func add_research(tech: base_tech_resource, timer):
	var new_tech = null
	match tech.tech_type:
		BuildingManager.tech_types.JOB_UNLOCK:
			new_tech = UnlockJobTech.new()
			new_tech.tech_resource = tech
			new_tech.timer = timer
		BuildingManager.tech_types.IMPROVE_CREATE_JOB:
			new_tech = ImproveJobTech.new()
			new_tech.tech_resource = tech
			new_tech.timer = timer
	if new_tech != null:
		add_child(new_tech) 
		new_tech.start_research()

func remove_research():
	for node in get_children():
		node.queue_free()
