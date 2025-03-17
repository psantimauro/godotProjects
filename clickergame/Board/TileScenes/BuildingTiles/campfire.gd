class_name CampFire
extends Node2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var progress_bar: TimerProgressBar = $ProgressBar
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var fuel_consuption_rate = 2.5
@export var  fuel_materials = [InventoryManager.material_types.WOOD]
@export var fire_multipler = 5.0
@export var group_type = TileManager.tile_types.BUILDING
@export var type = BuildingManager.building_types.CAMPFIRE
var keep_burning = true

const CAMPFIRE = preload("res://3rd Party/assets/icons/campfire.png")
const WOOD_ASHES = preload("res://3rd Party/assets/icons/wood_ashes.png")
signal selected

func _ready() -> void:
	progress_bar.done.connect(_on_timer_complete)
	await progress_bar.ready
	progress_bar.start()
func click():	
	if progress_bar.is_stopped():
		start_fire()
	else:
		pass
	selected.emit(self)
	
func _on_timer_complete():
	stop_fire()
	if keep_burning:
		start_fire()
func stop_fire():
	burn_wood(false) #stops the building improvment
	progress_bar.stop()
	gpu_particles_2d.visible = false
	sprite_2d.texture = WOOD_ASHES
	
func start_fire():		
	var has_materials = false
	for fuel_item in fuel_materials:
		var stack = material_stack.new()
		stack.material_amount = fuel_consuption_rate
		stack.material_type = fuel_item
		if InventoryManager.has_material_stack(stack):
			has_materials =true
			InventoryManager.remove_material_stack(stack)
			burn_wood(true)
			progress_bar.start()
			gpu_particles_2d.visible = true
			sprite_2d.texture = CAMPFIRE
			break
	if !has_materials:
		BuildingManager.display_message_with_title.emit("Get more wood, and click to restart", "No more wood to run Campfire")
		
func position_adjacent(pos_vect) -> bool:
	var adj = false
	var fire_position = get_position_from_name(name)
	for v in Globals.adjecent_vectors():
		if pos_vect == v + fire_position:
			adj = true
			break
	return adj
	
func burn_wood(running = true):
	#get all adjectent buildings and inprove there power	
	var building_str = Globals.get_name_from_type(TileManager.tile_types.BUILDING,TileManager.tile_types)
	for building in get_tree().get_nodes_in_group(building_str):
		var pos_vect = get_position_from_name(building.name)
		if position_adjacent(pos_vect):
			var direction = -1
			if running:
				direction = 1
			building.assist_building(fire_multipler)
			pass
			
func get_position_from_name(name):
	var parts:Array = name.split("_")
	if parts.size() > 1:
		return Globals.pos_string_to_vector2(parts[1])
		
func generate_building_action_menu():
	return null
