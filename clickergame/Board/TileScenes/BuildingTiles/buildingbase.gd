class_name BuildingBase
extends Node2D

@export var group_type: TileManager.tile_types = TileManager.tile_types.BUILDING
@export var type:BuildingManager.building_types = BuildingManager.building_types.UNDEFINED
@export var building_power = 1
@export var button_size = 75
@export var removal_restore_factor:float = 0.67
signal selected


@onready var work_ui: BuildingWork = $BuildingInterfaceItems/Job
@onready var research_ui: BuildingResearch = $BuildingInterfaceItems/Research

@onready var clickable_timer_progress_bar: ClickableProgressBar = $ClickableTimerProgressBar

@onready var research_controller: BuildingResearchController = %ResearchController
@onready var jobs_controller: BuildingJobController = %JobsController

var unlocked_jobs:Array[base_job_resource] = []
var unlocked_tech:Array[base_tech_resource] = []

func _ready() -> void:
	add_to_group(Globals.get_name_from_type(group_type, TileManager.tile_types))
	await clickable_timer_progress_bar
	BuildingManager.job_unlocked.connect(_on_job_unlocked)
	BuildingManager.tech_unlocked.connect(_on_tech_unlocked)
	for job in BuildingManager.unlocked_jobs_by_building[type]:
		_on_job_unlocked(job)
	for tech in BuildingManager.unlocked_tech_by_building[type]:
		_on_tech_unlocked(tech)

func click(power = building_power):
	if !clickable_timer_progress_bar.is_stopped():
		clickable_timer_progress_bar.click( power)
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
	clickable_timer_progress_bar.run_time = tech.research_speed * building_power
	clickable_timer_progress_bar.texture = BuildingManager.RESEARCH_ICON
	research_controller.add_research(tech, clickable_timer_progress_bar)
	current_activity = tech
	
func start_job(job: base_job_resource):
	stop_all()
	clickable_timer_progress_bar.texture = InventoryManager.get_resource_from_material_type(job.job_result.material_type).texture
	clickable_timer_progress_bar.run_time = job.job_speed * job.job_level * building_power
	jobs_controller.add_job(job, clickable_timer_progress_bar)
	current_activity = job

func _on_progress_bar_done() -> void:
	var tech = current_activity as base_tech_resource
	if tech != null:
		clickable_timer_progress_bar.stop()
	var job = current_activity as base_job_resource
	if job != null:
		clickable_timer_progress_bar.start()

func _on_job_unlocked(job, building_type = type):
	if building_type == type: 
		unlocked_jobs.append(job)
		work_ui.add_job(job)

func _on_tech_unlocked(tech, building_type = type):
	if building_type == type:
		unlocked_tech.append(tech)
		research_ui.add_research(tech)

func generate_building_action_menu():
	var building_menu = HBoxContainer.new()
	
	for item in %BuildingInterfaceItems.get_children():
		var button_container = VBoxContainer.new()
		
		var new_label = Label.new()
		new_label.text = item.name
		button_container.add_child(new_label)
		
		var new_btn = TextureButton.new()
		new_btn.name = item.name +"Button"
		new_btn.texture_normal = Globals.resize_texture(button_size, item.button_texture)
		var emit_self_lambda = func():
			BuildingManager.display_item.emit(item)
			building_menu.queue_free()
		new_btn.pressed.connect(emit_self_lambda)
		button_container.add_child(new_btn)
		building_menu.add_child(button_container)
		building_menu.add_child(VSeparator.new())
	
	building_menu.add_child(delete_button())
	return building_menu
	
func delete_button() -> Container:
	var button_container = VBoxContainer.new()
	var delete_lamba = func():
		var building_res = BuildingManager.get_resource_from_building_type(type)
		for building_requirement:material_stack in building_res.requirements:
			var amount = ceil( removal_restore_factor * building_requirement.material_amount)
			InventoryManager.add_material(building_requirement.material_type,amount)
		Globals.delete_selected_building.emit()
		self.queue_free()


	var new_label = Label.new()
	new_label.text = "Delete building"
	button_container.add_child(new_label)
		
	var new_btn = TextureButton.new()
	new_btn.name = "DeleteButton"
	new_btn.texture_normal = Globals.resize_texture(button_size, preload("res://3rd Party/assets/icons/card_outline_remove.png"))
	new_btn.pressed.connect(delete_lamba)
	button_container.add_child(new_btn)	
	
	return button_container
	
