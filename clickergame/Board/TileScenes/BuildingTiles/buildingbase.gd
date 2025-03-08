class_name BuildingBase
extends Node2D

@export var type:BuildingManager.building_types = BuildingManager.building_types.UNDEFINED
@export var building_power = 0.01

signal selected

@onready var research: BuildingResearch = $Research
@onready var work: BuildingWork = $Work
@onready var progress_bar: TimerProgressBar = $ProgressBar

@export var jobs: Array[base_job_resource]
@export var techs: Array[base_tech_resource]

func _ready() -> void:
	await progress_bar
	progress_bar.power_multipler = building_power

func click():
	update()
	selected.emit(self)

func update():
	jobs = BuildingManager.get_unlocked_jobs_for_building(type)
	for job in jobs:
		work.add_job(job)
	techs = BuildingManager.get_unlocked_research_by_building_type(type)
	for tech in techs:
		research.add_research(tech)
