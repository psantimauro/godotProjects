extends Node

enum quest_types {UNDEFINED = -1, TUTORIAL, COLLECT , COMPLETE_JOB , COMPLETE_RESEARCH}
enum reward_types {UNDEFINED = -1, RESEARCH = 1 , NEW_BUILDING = 2 , MATERIAL, JOB  }
enum quest_status_types {UNDEFINED = -1, STARTED, UPDATED, COMPLETED}
signal quest_status_changed

var completed_quest_count = 0
var active_quests = []
var material_quest_tracker: Dictionary[InventoryManager.material_types, int]={}
@export var firstquest_res_array =[
	load("res://Resources/quest_resources/first_clicks.tres"),
	#load("res://Resources/quest_resources/collect_wood2.tres")
]
@export var collectquests: Dictionary[InventoryManager.material_types, QuestResource]={
	InventoryManager.material_types.WOOD: preload("res://Resources/quest_resources/collect_wood2.tres")
}
func _ready() -> void:
	Questify.condition_query_requested.connect(_on_condition_query_requested)
	Questify.quest_completed.connect(_on_quest_completed)
	Questify.quest_objective_completed.connect(_on_objected_completed)
	Questify.quest_objective_added.connect(_on_objective_added)
	
func _on_condition_query_requested(query_type: String, key: String, value: Variant, requester: QuestCondition):
	match query_type:
		"has_material":
			if InventoryManager.has_material(key, int(value)):
				requester.set_completed(true)
		"has_building":
			if BuildingManager.is_building_unlocked(key):
				requester.set_completed(true)
		"material_multi":
			var multiple = pow( int(value) , QuestManager.collect_quest_muliplyer(key))
			if InventoryManager.has_material(key,multiple):
				requester.set_completed(true)
func _on_objected_completed(quest: QuestResource, objective: QuestObjective):
	var reward_name = objective.get_meta("reward_type")
	var reward_type:reward_types = Globals.get_type_from_name(reward_name, reward_types)
	match reward_type:
		reward_types.NEW_BUILDING:
			var building_name = objective.get_meta("building")
			var building_type:BuildingManager.building_types = Globals.get_type_from_name(building_name, BuildingManager.building_types)
			BuildingManager.unlock_building(building_type)
			quest_status_changed.emit(quest, quest_status_types.UPDATED, objective.description)
			print("new building")
		reward_types.JOB:
			var building_name = objective.get_meta("building")
			var job_type_name = objective. get_meta("res_name")
			var building_type:BuildingManager.building_types = Globals.get_type_from_name(building_name, BuildingManager.building_types)
			BuildingManager.unlock_job_for_building_by_name(building_type, job_type_name)
			print("new jobs")
		reward_types.RESEARCH:
			var building = objective.get_meta("building")
			var tech_type_name = objective. get_meta("res_name")
			var buildng_type = Globals.get_type_from_name(building, BuildingManager.building_types)
			BuildingManager.unlocked_tech_for_building(buildng_type, tech_type_name)
			print("new reseach")
		reward_types.MATERIAL:
			var material_name:String = objective.get_meta("material")
			var material_amount = objective.get_meta("amount")
			var material_type:InventoryManager.material_types = Globals.get_type_from_name(material_name,InventoryManager.material_types)
			InventoryManager.add_material(material_type, material_amount)
			print("new materials")

func _on_objective_added(quest: QuestResource, objective: QuestObjective):
	quest_status_changed.emit(quest, quest_status_types.UPDATED, objective.description)

func _on_quest_completed(quest: QuestResource):
	var idx = get_quest_id(quest) 
	completed_quest_count += 1
	quest_status_changed.emit(quest, quest_status_types.COMPLETED, "Complete")
	active_quests.remove_at(idx)
		
	var name:String = quest.name
	if name.contains("_"):
		var parts = name.split("_")
		var type = parts[0]
		match type:
			"collect":
				var mat_name = parts[1]
				var mat_type = Globals.get_type_from_name(mat_name,InventoryManager.material_types)
				if !material_quest_tracker.has(mat_type):
					material_quest_tracker[mat_type] = 0
				material_quest_tracker[mat_type] += 1
				QuestManager.add_quest(collectquests[mat_type].instantiate())


	
func collect_quest_muliplyer(key):
	var type = Globals.get_type_from_name(key, InventoryManager.material_types)
	if material_quest_tracker.has(type):
		return material_quest_tracker[type]
	return 1

func get_quest_name(id):
	var q = active_quests[id]
	return q.name
func get_quest_id(quest) -> int:
	return active_quests.find(quest)

func add_quest(quest):
	active_quests.append(quest)
	Questify.start_quest(quest)
	quest_status_changed.emit(quest, quest_status_types.STARTED, quest.description)
