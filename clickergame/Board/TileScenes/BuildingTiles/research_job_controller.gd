class_name BuildingResearchController
extends Node

func add_research(research: base_tech_resource, timer):
	remove_research()
	var new_tech: UnlockJobTech = UnlockJobTech.new()
	new_tech.tech_resource = research
	new_tech.timer = timer
	
	add_child(new_tech)
	new_tech.start_research()


func remove_research():
	for node in get_children():
		node.queue_free()
