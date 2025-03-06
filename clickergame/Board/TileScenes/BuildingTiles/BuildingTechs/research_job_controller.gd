class_name BuildingResearchController
extends Node

func add_research(tech: base_tech_resource, timer):
	remove_research()
	var new_tech: UnlockJobTech = UnlockJobTech.new()
	new_tech.tech_resource = tech
	new_tech.timer = timer
	
	add_child(new_tech)
	new_tech.start_research()


func remove_research():
	for node in get_children():
		node.queue_free()
