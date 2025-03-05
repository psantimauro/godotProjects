class_name BuildingResearch
extends Control

@onready var progress_bar: TimerProgressBar = $"../ProgressBar"
@onready var research_container: Node = $ResearchContainer

var button_group: ButtonGroup = ButtonGroup.new()

const TENT_CREATE_MEAT = preload("res://Resources/tech_resources/job_unlock_tech/Tent_Create_Meat.tres")
func add_research(research_tech:job_unlock_tech = TENT_CREATE_MEAT):
	progress_bar.timer_duration = research_tech.research_speed
	progress_bar.texture = preload("res://3rd Party/assets/icons/flask_half.png")
	research_container.add_research(research_tech, progress_bar)


func _on_button_pressed() -> void:
	add_research()
	Globals.clear_selection.emit()
