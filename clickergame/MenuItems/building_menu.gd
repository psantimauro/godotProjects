class_name BuildingMenu
extends HBoxContainer

@onready var work_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/Panel/WorkContainer/Button
@onready var research_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/ResearchContainer/Button

@onready var display_container: PanelContainer = $"../../DisplayContainer"


func _ready() -> void:
	research_button.pressed.connect(_research_button_clicked)
	work_button.pressed.connect(_work_button_clicked)
	
var building: BuildingBase

func _research_button_clicked():
	display_container.set_item(building.research)

func _work_button_clicked():
	display_container.set_item(building.work)
