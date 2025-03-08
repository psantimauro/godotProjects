extends Node

enum quest_types {UNDEFINED = -1, TUTORIAL, COLLECT , COMPLETE_JOB , COMPLETE_RESEARCH}
enum reward_types {UNDEFINED = -1, RESEARCH , NEW_BUILDING , MATERIALS, JOBS  }
enum quest_status_types {UNDEFINED = -1, STARTED, UPDATED, COMPLETED}
signal quest_status_changed

var completed_quest_count = 0
var active_quests = []

@export var firstquest_res = preload("res://Resources/quest_resources/first_clicks.tres")
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

func _on_objected_completed(quest: QuestResource, objective: QuestObjective):
	var reward_type = objective.get_meta("reward_type")
	var building_type = objective.get_meta("reward_value")
	if reward_type ==	QuestManager.reward_types.NEW_BUILDING:
			InventoryManager.unlock_building(int(building_type))
			quest_status_changed.emit(quest, quest_status_types.UPDATED, objective.description)
			print("new building")
	elif reward_type == QuestManager.reward_types.RESEARCH:
			print("new reseach")
	print("no objective match")
func _on_objective_added(quest: QuestResource, objective: QuestObjective):
	quest_status_changed.emit(quest, quest_status_types.UPDATED, objective.description)
	
func _on_quest_completed(quest: QuestResource):
	var idx = get_quest_id(quest) 
	completed_quest_count += 1
	quest_status_changed.emit(quest, quest_status_types.COMPLETED, "Complete")
	active_quests.remove_at(idx)

func get_quest_name(id):
	var q = active_quests[id]
	return q.name
func get_quest_id(quest) -> int:
	return active_quests.find(quest)

func add_quest(quest):
	active_quests.append(quest)
	Questify.start_quest(quest)
	quest_status_changed.emit(quest, quest_status_types.STARTED, quest.description)
	
