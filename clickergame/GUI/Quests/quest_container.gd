extends PanelContainer

@export var tutorial_quest_type: VBoxContainer
@export var repeatable_quest_type: VBoxContainer

@export var audio_stream_player_2d: AudioStreamPlayer2D
@onready var quest_counter: Label = %"Quest Counter"

func _ready() -> void:
	GameEvents.quest_status_changed.connect(_on_quest_status_changed)

func _on_quest_status_changed(quest, status, description, quest_type):
	var name = quest.name
	match status:
		QuestManager.quest_status_types.STARTED:
			add_quest(name, description, quest_type)
		QuestManager.quest_status_types.UPDATED:
			update_quest(name, description, quest_type)
		QuestManager.quest_status_types.COMPLETED:
			audio_stream_player_2d.play()
			var count = QuestManager.completed_quest_count
			if count > 0:
				quest_counter.text = "Completed: " + str(count)
			remove_quest(name, quest_type)
	check_view_hide()

func update_quest(name, description, quest_type):
	var path = ""
	if quest_type == "main":
		path = str(tutorial_quest_type.get_path())
		path += "/" + name
		var node = tutorial_quest_type.get_node(path)
		if node:
			node.text = name + ": " + description
	elif quest_type == "collect":
		path = str(repeatable_quest_type.get_path())
		path += "/" + name
		var node = repeatable_quest_type.get_node(path)
		if node:
			node.text = name + ": " + description
		
func add_quest(name, description, quest_type):
	var quest_item = Label.new()
	quest_item.name = name
	match quest_type:
		"main":
			tutorial_quest_type.add_child(quest_item)
		"collect":
			repeatable_quest_type.add_child(quest_item)
	update_quest(name, description, quest_type)

func remove_quest(name, quest_type):
	var path = ""
	if quest_type == "main":
		path = str(tutorial_quest_type.get_path())
		path += "/" + name
		var node = tutorial_quest_type.get_node(path)
		tutorial_quest_type.remove_child(node)
	elif quest_type == "collect":
		path = str(repeatable_quest_type.get_path())
		path += "/" + name
		var node = repeatable_quest_type.get_node(path)
		repeatable_quest_type.remove_child(node)

func check_view_hide():
	if tutorial_quest_type.get_child_count() == 0 && repeatable_quest_type.get_child_count() == 0:
		visible = false
	else:
		visible = true
