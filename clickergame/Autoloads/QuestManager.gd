extends Node

enum reward_types {RESEARCH = 1, NEW_BUILDING = 2 }
enum quest_status_types {STARTED, UPDATED, COMPLETED}
signal quest_status_changed

func _ready() -> void:
	Questify.condition_query_requested.connect(_on_condition_query_requested)
	Questify.quest_completed.connect(_on_quest_completed)
	Questify.quest_objective_completed.connect(_on_objected_completed)
	
func _on_condition_query_requested(type: String, key: String, value: Variant, requester: QuestCondition):
	match type:
		"has_material":
			var mat_stack = material_stack.new()
			mat_stack.material_type = key.to_int()
			mat_stack.material_amount= value
			if InventoryManager.has_material_stack(mat_stack):
				requester.set_completed(true)

func _on_objected_completed(quest: QuestResource, objective: QuestObjective):
	var reward_type = objective.get_meta("reward_type")
	var building_type = objective.get_meta("reward_value")
	if reward_type ==	QuestManager.reward_types.NEW_BUILDING:
			InventoryManager.unlock_building(int(building_type))
			quest_status_changed.emit(quest, quest_status_types.UPDATED)
			print("new building")
	elif reward_type == QuestManager.reward_types.RESEARCH:
			print("new reseach")
	print("no objective match")

func _on_quest_completed(quest: QuestResource):

	var idx = get_quest_id(quest)
	quest_status_changed.emit(quest, quest_status_types.COMPLETED)
	active_quests.remove_at(idx)

func get_quest_name(id):
	var q = active_quests[id]
	return q.name
func get_quest_id(quest) -> int:
	return active_quests.find(quest)
var active_quests = []
func add_quest(quest):
	active_quests.append(quest)
	Questify.start_quest(quest)
	var idx = get_quest_id(quest)
	quest_status_changed.emit(quest, quest_status_types.STARTED)
	
