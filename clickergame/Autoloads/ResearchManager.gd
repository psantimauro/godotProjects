extends Node
const TENT_CREATE_MEAT = preload("res://Resources/tech_resources/job_unlock_tech/Tent_Create_Meat.tres")

var unlocked_research = Array[base_tech_resource]

func unlock_research(tech:base_tech_resource):
	if unlocked_research != null:
		unlocked_research.append(tech)
		
func get_unlocked_research_by_building_type(type: InventoryManager.building_types):
	var unlocked = Array[base_tech_resource]
	for tech: base_tech_resource in unlocked_research:
		if tech.required_building == type:
			unlocked.append(tech)
	return unlocked
	
