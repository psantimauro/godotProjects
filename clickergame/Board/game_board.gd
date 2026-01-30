extends Node

@export var x_size = 10
@export var y_size = 10

@onready var game_layer: TileMapLayer = $GameLayer
@onready var ground_layer: TileMapLayer = $GroundLayer

@onready var selection_indictor = $Selection
@onready var camera_2d: Camera2D = $Camera2D
@onready var regeneration_timer: Timer = $RegenerationTimer

const SCENE_COLLECTION = Vector2i.ZERO
const RESOURCE = 0
const BUILDING = 1
const PICKUP = 2
const ANIMAL = 3
var last_board_click = Vector2i.ONE * -1

func _ready() -> void:
	GameEvents.building_built.connect(_on_building_built)
	GameEvents.clear_selection.connect(_on_selection_cleared)
	GameEvents.delete_selected_building.connect(_delete_selected_building)
	generate_game_board()
	regeneration_timer.timeout.connect(_on_regeneration_timer_timeout)

func _unhandled_input(event: InputEvent) -> void:
	if ((event is InputEventMouse) and event.is_action_pressed("click")):
		var selected_game_tile = game_layer.get_cell_scene(GetLastClickPosition(event))
		var global_map_postiion_from_click_position = GetGlobalClickPosition(event)
		last_board_click = GetLastClickPosition(event)
		print("Tile Clicked: " + str(last_board_click) + " @ global" + str(global_map_postiion_from_click_position))
		if (selected_game_tile != null):
			var type: TileManager.tiles = selected_game_tile.get_meta("type")

			if TileManager.IsTypeResource(type):
				selected_game_tile.click()
			elif TileManager.IsTypePickup(type):
				selected_game_tile.pickup()
			elif TileManager.IsTypeBuilding(type) || TileManager.IsTypeTrader(type):
				camera_2d.move_to(global_map_postiion_from_click_position)
				selected_game_tile.click()
			#	selection_indictor.visible = false
				selection_indictor.position = global_map_postiion_from_click_position
			elif TileManager.IsTypeAnimal(type):
				selected_game_tile.click()
				
		else:
			selection_indictor.position = global_map_postiion_from_click_position
		#	selection_indictor.visible = !selection_indictor.visible

			GameEvents.empty_tile_selected.emit(last_board_click)
			#if selection_indictor.visible:
				#camera_2d.move_to(selection_indictor.position)

func generate_game_board():
	var x_min = - x_size
	var y_min = - y_size
	for x in range(x_min, x_size + 1):
		for y in range(y_min, y_size + 1):
			var cords = (Vector2i(x, y))
			ground_layer.set_cell(cords, RESOURCE, SCENE_COLLECTION, TileManager.tiles.GRASS)
			
			if x == 0 and y == 0:
				game_layer.set_cell(cords, PICKUP, SCENE_COLLECTION, TileManager.tiles.GENERIC_PICKUP)
			elif x == 1 and y == 1:
				game_layer.set_cell(cords, PICKUP, SCENE_COLLECTION, TileManager.tiles.GENERIC_PICKUP)
			else:
				var dice = randi_range(1, 6)
				if dice == TileManager.tiles.TREE or dice - 1 == TileManager.tiles.TREE:
					game_layer.set_cell(cords, RESOURCE, SCENE_COLLECTION, TileManager.tiles.TREE)
				elif dice == TileManager.tiles.ROCK:
					game_layer.set_cell(cords, RESOURCE, SCENE_COLLECTION, TileManager.tiles.ROCK)
				elif dice == 6:
					dice = randi_range(1, 6)
					if dice == 6:
						game_layer.set_cell(cords, ANIMAL, SCENE_COLLECTION, TileManager.tiles.DEER)
	
	await get_tree().create_timer(0.01).timeout # this is a hack to get these setup one they are on the board
	var axe = game_layer.scene_coords[(Vector2i(0, 0))]
	var image = Utilities.resize_texture(64, preload("res://3rd Party/assets/icons/axe.png"))
	axe.icon = image
	axe.type = ToolManager.tool_types.AXE
	
	var knife = game_layer.scene_coords[(Vector2i(1, 1))]
	image = Utilities.resize_texture(64, preload("res://3rd Party/assets/icons/knife.png"))
	knife.icon = image
	knife.type = ToolManager.tool_types.KNIFE

func get_last_resource():
	return get_resource_at_position(last_board_click)
func get_resource_at_position(pos):
	return game_layer.get_cell_scene(pos)
func clear_last_resource():
	clear_resource_at_position(last_board_click)
func clear_resource_at_position(pos):
	game_layer.set_cell(pos, 0, SCENE_COLLECTION, -1)

func _on_building_built(building_type):
	var coords = ground_layer.local_to_map(selection_indictor.position)
	game_layer.set_cell(coords, BUILDING, SCENE_COLLECTION, building_type)

func _on_selection_cleared():
	#selection_indictor.visible = false
	pass

func _delete_selected_building():
	var selected_game_tile = game_layer.get_cell_scene(ground_layer.local_to_map(selection_indictor.position))
	if TileManager.IsTypeBuilding(selected_game_tile.get_meta("type")):
		clear_last_resource()
		
func resource_destroyed(yielded_resources):
	var resource = get_last_resource()
	if resource:
		if resource.yield_type != InventoryManager.material_types.UNDEFINED:
			InventoryManager.add_material(resource.yield_type, yielded_resources)
			clear_last_resource()

func GetLastClickPosition(event):
	var board_local_click = ground_layer.make_input_local(event)
	var board_position = ground_layer.local_to_map(board_local_click.position)
	return Vector2i(board_position)

func GetGlobalClickPosition(event):
	var board_local_click = ground_layer.make_input_local(event)
	var board_position = ground_layer.local_to_map(board_local_click.position)
	return ground_layer.map_to_local(board_position)

func _on_regeneration_timer_timeout():
	var x = randi_range(-x_size, x_size)
	var y = randi_range(-y_size, y_size)
	var coords = Vector2(x, y)
	var res = get_resource_at_position(coords)
	var generated = false
	if res == null:
		var dice = randi_range(1, 6)
		if dice == 1 or dice == 2:
			generated = true
			game_layer.set_cell(coords, RESOURCE, SCENE_COLLECTION, TileManager.tiles.TREE)
		elif dice == 3:
			if BuildingManager.traders_unlocked:
				var traders = get_tree().get_nodes_in_group("Trader")
				if traders.size() == 0:
					game_layer.set_cell(coords, BUILDING, SCENE_COLLECTION, TileManager.tiles.TIPI)
					GameEvents.display_message_with_title.emit("Find the Tipi and on the map and select it to interact.", "A new trader arrived!")
		elif dice == 5:
			generated = true
			game_layer.set_cell(coords, ANIMAL, SCENE_COLLECTION, TileManager.tiles.DEER)
		elif dice == 6:
			generated = true
			dice = randi_range(1, 6)
			if dice == 6:
				game_layer.set_cell(coords, PICKUP, SCENE_COLLECTION, TileManager.tiles.MUSHROOM)
	if generated:
		regeneration_timer.wait_time = randi_range(5, 8)
	else:
		regeneration_timer.wait_time = randi_range(3, 5)
	regeneration_timer.start()
