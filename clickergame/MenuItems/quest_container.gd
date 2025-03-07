extends PanelContainer

@onready var quest_list: VBoxContainer = $VBoxContainer/QuestList
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	QuestManager.quest_status_changed.connect(_on_quest_status_changed)

func _on_quest_status_changed(quest, status: QuestManager.quest_status_types):
	var description = quest.description
	var name = quest.name
	match status:
		QuestManager.quest_status_types.STARTED:
			add_quest(name, description)
		QuestManager.quest_status_types.UPDATED:
			update_quest(name, description)
		QuestManager.quest_status_types.COMPLETED:
			audio_stream_player_2d.play()
			remove_quest(name)
	check_view_hide()

func update_quest(name, description):
	var path = str(quest_list.get_path()) + "/" + name
	var node = quest_list.get_node(path)
	node.text = name + ": " +description
	
func add_quest(name, description):
	var quest_item = Label.new()
	quest_item.name = name
	quest_list.add_child(quest_item)
	update_quest(name, description)

func remove_quest(name):
	
	var path = str(quest_list.get_path()) + "/" + name
	var node = quest_list.get_node(path)
	quest_list.remove_child(node)

func check_view_hide():
	if quest_list.get_child_count() == 0:
		visible = false
	else:
		visible = true
	
