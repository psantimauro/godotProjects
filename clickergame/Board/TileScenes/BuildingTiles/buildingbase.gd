class_name BuildingBase
extends Node2D

@export var group_type: TileManager.tile_types = TileManager.tile_types.BUILDING
@export var type:BuildingManager.building_types = BuildingManager.building_types.UNDEFINED
@export var building_power = 0.01

signal selected

@onready var research_ui: BuildingResearch = $Research
@onready var work_ui: BuildingWork = $Work
@onready var progress_bar: TimerProgressBar = $ProgressBar
@onready var research_controller: BuildingResearchController = %ResearchController
@onready var jobs_controller: BuildingJobController = %JobsController

var unlocked_jobs:Array[base_job_resource] = []
var unlocked_tech:Array[base_tech_resource] = []

func _ready() -> void:
	add_to_group(Globals.get_name_from_type(group_type, TileManager.tile_types))
	await progress_bar
	progress_bar.power_multipler = building_power
	BuildingManager.job_unlocked.connect(_on_job_unlocked)
	BuildingManager.tech_unlocked.connect(_on_tech_unlocked)
	for job in BuildingManager.unlocked_jobs_by_building[type]:
		_on_job_unlocked(job)
	for tech in BuildingManager.unlocked_tech_by_building[type]:
		_on_tech_unlocked(tech)

func click():
	selected.emit(self)

func active() -> bool:
	return false

func update_jobs():
	work_ui.clear()
	for job in unlocked_jobs:
		work_ui.add_job(job)

func update_tech():
	research_ui.clear()
	for tech in unlocked_tech:
		research_ui.add_research(tech)
		
var current_activity
func stop_all():
	jobs_controller.remove_jobs()
	research_controller.remove_research()
	
func start_research(tech):
	stop_all()
	progress_bar.power_multipler = tech.research_speed * building_power
	progress_bar.texture = BuildingManager.RESEARCH_ICON
	research_controller.add_research(tech, progress_bar)
	current_activity = tech
	
func start_job(job: base_job_resource):
	stop_all()
	progress_bar.texture = InventoryManager.get_resource_from_material_type(job.job_result.material_type).texture
	progress_bar.power_multipler = job.job_speed * building_power
	jobs_controller.add_job(job, progress_bar)
	current_activity = job

func _on_progress_bar_done() -> void:
	var tech = current_activity as base_tech_resource
	if tech != null:
		progress_bar.stop()
	var job = current_activity as base_job_resource
	if job != null:
		progress_bar.start()

func _on_job_unlocked(job, building_type = type):
	if building_type == type: 
		unlocked_jobs.append(job)
		work_ui.add_job(job)

func _on_tech_unlocked(tech, building_type = type):
	if building_type == type:
		unlocked_tech.append(tech)
		research_ui.add_research(tech)
