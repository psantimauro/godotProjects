class_name Well
extends Node2D

signal selected
@export var group_type = TileManager.tile_types.BUILDING
@export var type = BuildingManager.building_types.WELL

func assist_building(amount):
	pass 

func generate_building_action_menu():
	return null
	
	
@export var fill_rate = 0.5
@export var fill_speed = 1
@export var _bucket_removal_amount = 25

@onready var fill_bar: ProgressBar = $FillBar
@onready var fill_timer: Timer = $FillTimer
@onready var clickable_timer_progress_bar: ClickableProgressBar = $ClickableTimerProgressBar


func _ready() -> void:
	add_to_group(Globals.get_name_from_type(group_type, TileManager.tile_types))
	fill_timer.wait_time = fill_speed
	clickable_timer_progress_bar.done.connect(_on_clickable_timer_done)

func _on_timer_timeout() -> void:
	fill_bar.value += fill_rate
	fill_timer.wait_time = fill_speed

func click():
	if clickable_timer_progress_bar.is_stopped() && fill_bar.value >= _bucket_removal_amount:
		clickable_timer_progress_bar.show()
		clickable_timer_progress_bar.start()
	selected.emit(self)

func _on_clickable_timer_done():
	fill_bar.value -= _bucket_removal_amount
	InventoryManager.add_material(InventoryManager.material_types.WATER, _bucket_removal_amount)
	clickable_timer_progress_bar.hide()
