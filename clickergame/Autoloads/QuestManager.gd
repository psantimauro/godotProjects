extends Node

enum quest_types {UNDEFINED = -1, TUTORIAL, COLLECT , COMPLETE_JOB , COMPLETE_RESEARCH}
enum reward_types {UNDEFINED = -1, RESEARCH = 1 , NEW_BUILDING = 2 , MATERIAL, JOB , TRADER }
enum quest_status_types {UNDEFINED = -1, STARTED, UPDATED, COMPLETED}
signal quest_status_changed

var completed_quest_count = 0
var active_quests = []
var material_quest_tracker: Dictionary[InventoryManager.material_types, int]={}
@export var firstquest_res_array =[
	load("res://Resources/quest_resources/first_clicks.tres"),
]

const COLLECT_MAT_QUEST = preload("res://Resources/quest_resources/collect_material.tres")

func _ready() -> void:
	InventoryManager.new_material_unlocked.connect(_on_new_material_unlocked)
	Questify.condition_query_requested.connect(_on_condition_query_requested)
	Questify.quest_completed.connect(_on_quest_completed)
	Questify.quest_objective_completed.connect(_on_objected_completed)
	Questify.quest_objective_added.connect(_on_objective_added)
	
func _on_new_material_unlocked(mat_type):
	QuestManager.add_collect_material_quest(COLLECT_MAT_QUEST.instantiate(), mat_type.res_type)

func _on_condition_query_requested(query_type: String, key: String, value: Variant, requester: QuestCondition):
	match query_type:
		"has_material":
			if InventoryManager.has_material(key, int(value)):
				requester.set_completed(true)
		"has_building":
			if BuildingManager.is_building_unlocked(key):
				requester.set_completed(true)
		"has_tool":
			var tool_type = Globals.get_type_from_name(key, ToolManager.tool_types)
			if tool_type != ToolManager.tool_types.UNDEFINED && ToolManager.has_tool(tool_type):
				requester.set_completed(true)
		"material_multi":
			var multiple = QuestManager.collect_quest_muliplyer(value, key) 
			if InventoryManager.has_material(key,multiple):
				requester.set_completed(true)
				
func _on_objected_completed(quest: QuestResource, objective: QuestObjective):
	var reward_name = objective.get_meta("reward_type")
	if reward_name != null:
		var reward_type:reward_types = Globals.get_type_from_name(reward_name, reward_types)
		match reward_type:
			reward_types.NEW_BUILDING:
				var building_name = objective.get_meta("building")
				var building_type:BuildingManager.building_types = Globals.get_type_from_name(building_name, BuildingManager.building_types)
				BuildingManager.unlock_building(building_type)
				quest_status_changed.emit(quest, quest_status_types.UPDATED, objective.description, quest.get_meta("quest_type"))
				print("new building")
			reward_types.JOB: #IS THIS CODE DEAD?
				var building_name = objective.get_meta("building")
				var job_type_name = objective.get_meta("res_name")
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
			reward_types.TRADER:
				Globals.traders_unlocked = true
				print("unlock trading")

func _on_objective_added(quest: QuestResource, objective: QuestObjective):
	var quest_type = quest.get_meta("quest_type")
	if quest_type == "main":
		quest_status_changed.emit(quest, quest_status_types.UPDATED, objective.description, quest_type)
	elif quest_type == "collect":
		quest_status_changed.emit(quest, quest_status_types.UPDATED, objective.description, quest_type)

func _on_quest_completed(quest: QuestResource):
	var idx = active_quests.find(quest)
	completed_quest_count += 1
	
	var quest_type = quest.get_meta("quest_type")
	quest_status_changed.emit(quest, quest_status_types.COMPLETED, "Complete", quest_type)
	active_quests.remove_at(idx)
	var quest_name:String = quest.name
	if quest_name.contains(" "):
		var parts = quest_name.split(" ")
		match quest_type:
			"collect":
				var mat_name = parts[1]
				collect_quest_completed(mat_name)
			_:
				print("tutorial complete")
func collect_quest_completed(material_name: String):
	var mat_type = Globals.get_type_from_name(material_name,InventoryManager.material_types)
	if !material_quest_tracker.has(mat_type):
		material_quest_tracker[mat_type] = 0
	material_quest_tracker[mat_type] += 1
	#restart the quest
	add_collect_material_quest(COLLECT_MAT_QUEST.instantiate(), mat_type)
	
	#collect quests unlock new research
	var amount = material_quest_tracker[mat_type]

	var building_level =  int(amount /3) 
	var unlock_type = int(amount%3)
	var job = unlock_type == 1
	var research = unlock_type == 2
	match building_level:
		0: #tend
			if BuildingManager.is_building_unlocked("tent"):
				if job == true:
					BuildingManager.unlock_mat_create_job_for_building_by_mat_name(BuildingManager.building_types.TENT,material_name)
				elif research == true:
					BuildingManager.unlocked_improve_job_tech_for_building_by_material_name(BuildingManager.building_types.TENT,material_name)
		1: #logcabin
			if job == true:
				BuildingManager.unlock_mat_create_job_for_building_by_mat_name(BuildingManager.building_types.LOGCABIN,material_name)
		2: #plank
			pass

func collect_quest_muliplyer(value, key):
	var power =  QuestManager.collect_quest_count(key)
	return int(pow( int(value) ,power))
	
func collect_quest_count(key):
	var type = Globals.get_type_from_name(key, InventoryManager.material_types)
	if material_quest_tracker.has(type):
		return material_quest_tracker[type]
	return 1

func add_main_quest(quest):
	quest.set_meta("quest_type", "main")
	QuestManager.add_quest(quest)
	add_quest(quest)
	
func add_collect_material_quest(quest, type):
	var mat_name = Globals.get_name_from_type(type, InventoryManager.material_types)
	quest.set_meta("quest_type", "collect")
	var start_node = quest.start_node
	start_node.name = start_node.name.replace("{mat}", mat_name)
	var multiple = QuestManager.collect_quest_muliplyer(10, mat_name) #ten maps to the quest's definition
	start_node.description = start_node.description.replace("{mat}", mat_name).replace("{amount}", str(multiple))
	start_node.set_meta("material", mat_name)
	for objective in quest.get_objectives():
		objective.description = objective.description.replace("{mat}", mat_name).replace("{amount}", str(multiple))
	for condition in quest.get_conditions():
		condition.key = condition.key.replace("{mat}", mat_name).replace("{amount}", str(multiple))
	
	add_quest(quest)
	
func add_quest(quest):
	var quest_type = quest.get_meta("quest_type")
	active_quests.append(quest)
	quest_status_changed.emit(quest, quest_status_types.STARTED, quest.description, quest_type)
	Questify.start_quest(quest)
	
