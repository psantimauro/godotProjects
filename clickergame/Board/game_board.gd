extends Node

@export var x_size = 10
@export var y_size = 10

@onready var game_layer =  $GameLayer
@onready var ground_layer = $GroundLayer
#@onready var building_layer =  $BuildingLayer
@onready var selection_indictor = $Selection
@onready var camera_2d: Camera2D = $Camera2D

const SCENE_COLLECTION = Vector2i.ZERO
const RESOURCE = 0
const BUILDING = 1
const PICKUP = 2
var last_board_click = Vector2i.ONE * -1

func _ready() -> void:
	BuildingManager.building_built.connect(_on_building_build)
	Globals.clear_selection.connect(_on_selection_cleared)
	Globals.delete_selected_building.connect(_delete_selected_building)
	generate_game_board()

func _unhandled_input(event: InputEvent) -> void:
	if((event is InputEventMouse) and event.is_action_pressed("click")):
		var selected_game_tile = game_layer.get_cell_scene( GetLastClickPosition(event))
		var global_map_postiion_from_click_position = GetGlobalClickPosition(event)
		last_board_click = GetLastClickPosition(event)
		print("Tile Clicked: " + str(last_board_click) + " @ global" +str(global_map_postiion_from_click_position))
		
		if(selected_game_tile != null):
			var type:TileManager.tiles = selected_game_tile.get_meta("type") 

			if  TileManager.IsTypeResource(type):	
				selected_game_tile.click()
				Globals.resource_clicked.emit()
			elif TileManager.IsTypePickup(type):
				selected_game_tile.pickup()
			elif TileManager.IsTypeBuilding(type):
				camera_2d.move_to(global_map_postiion_from_click_position)
				selected_game_tile.click()
			#	selection_indictor.visible = false
				selection_indictor.position = global_map_postiion_from_click_position
				
		else:
			selection_indictor.position = global_map_postiion_from_click_position
		#	selection_indictor.visible = !selection_indictor.visible

			Globals.empty_tile_selected.emit(last_board_click)
			#if selection_indictor.visible:
				#camera_2d.move_to(selection_indictor.position)

func generate_game_board():
	var x_min = -x_size
	var y_min = -y_size
	for x in range (x_min, x_size):
		for y in range(y_min, y_size):
			var cords = (Vector2i(x,y))
			ground_layer.set_cell(cords,RESOURCE,SCENE_COLLECTION,TileManager.tiles.GRASS)
			
			if x == 0 and y== 0:
				game_layer.set_cell(cords,PICKUP,SCENE_COLLECTION,TileManager.tiles.PICKUP)
			else:
				var dice = randi_range(1,6) 
				if dice == TileManager.tiles.TREE or  dice-1 == TileManager.tiles.TREE:
					game_layer.set_cell(cords,RESOURCE,SCENE_COLLECTION,TileManager.tiles.TREE)
				elif dice == TileManager.tiles.ROCK:
					game_layer.set_cell(cords,RESOURCE,SCENE_COLLECTION,TileManager.tiles.ROCK)

func get_last_resource():
	return get_resource_at_position(last_board_click)
func get_resource_at_position(pos):
	return game_layer.get_cell_scene(pos)
func clear_last_resource():
	clear_resource_at_position(last_board_click)
func clear_resource_at_position(pos):
	game_layer.set_cell(pos,0,SCENE_COLLECTION,-1)

func _on_building_build(building_type):
#	selection_indictor.visible = !selection_indictor.visible
	var coords =  ground_layer.local_to_map(selection_indictor.position)
	game_layer.set_cell(coords,BUILDING,SCENE_COLLECTION, building_type)
	
func _on_selection_cleared():
	#selection_indictor.visible = false
	pass

func _delete_selected_building():
	var selected_game_tile= game_layer.get_cell_scene(ground_layer.local_to_map(selection_indictor.position))
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
