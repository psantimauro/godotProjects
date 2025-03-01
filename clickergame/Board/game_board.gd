extends Node

@export var x_size = 25
@export var y_size = 25

@onready var resource_layer =  $ResourceLayer
@onready var ground_layer = $GroundLayer
@onready var building_layer =  $BuildingLayer
@onready var selection_indictor = $Selection
@onready var camera_2d: Camera2D = $Camera2D

const SCENE_COLLECTION = Vector2i.ZERO
var last_board_click = Vector2i.ONE * -1

func _ready() -> void:
	InventoryManager.building_built.connect(_on_building_build)
	generate_game_board()
	camera_2d.move_to( ground_layer.map_to_local(Vector2(x_size, y_size)))

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("click")):
		if(event is InputEventMouse):
			var board_local_click = ground_layer.make_input_local(event)
			var board_position = ground_layer.local_to_map(board_local_click.position)
			var global_map_postiion_from_click_position = ground_layer.map_to_local(board_position)
			last_board_click = Vector2i(board_position)

			var resource = resource_layer.get_cell_scene(last_board_click)
			var selected_building = building_layer.get_cell_scene(last_board_click)
			
			if  resource and !collecting:
				$Camera2D.move_to(global_map_postiion_from_click_position)
				var type:TileManager.tiles = resource.get_meta("type") 
				if type == TileManager.tiles.PICKUP:
					resource.pickup()
				elif type > 2:
					resource.click()
				GlobalSignals.resource_clicked.emit()
			elif selected_building :
				$Camera2D.move_to(global_map_postiion_from_click_position)
				selected_building.click()
				selection_indictor.visible = false
				selection_indictor.position = global_map_postiion_from_click_position
			else:
				selection_indictor.position = global_map_postiion_from_click_position
				selection_indictor.visible = !selection_indictor.visible
				
				GlobalSignals.empty_tile_selected.emit(last_board_click)
				if selection_indictor.visible:
					$Camera2D.move_to(selection_indictor.position)

				print("build pos: " + str(last_board_click))

func generate_game_board():
	var x_min = -x_size
	var y_min = -y_size
	for x in range (x_min, x_size):
		for y in range(y_min, y_size):
			var cords = (Vector2i(x,y))
			ground_layer.set_cell(cords,0,SCENE_COLLECTION,TileManager.tiles.GRASS)
			if x == 0 and y== 0:
				resource_layer.set_cell(cords,0,SCENE_COLLECTION,TileManager.tiles.PICKUP)
			else:
				var dice = randi_range(1,6) 
				if dice == TileManager.tiles.TREE:
					resource_layer.set_cell(cords,0,SCENE_COLLECTION,TileManager.tiles.TREE)
				elif dice == TileManager.tiles.ROCK:
					resource_layer.set_cell(cords,0,SCENE_COLLECTION,TileManager.tiles.ROCK)

func get_last_resource():
	return get_resource_at_position(last_board_click)
func get_resource_at_position(pos):
	return resource_layer.get_cell_scene(pos)
func clear_last_resource():
	clear_resource_at_position(last_board_click)
func clear_resource_at_position(pos):
	resource_layer.set_cell(pos,0,SCENE_COLLECTION,-1)

func _on_building_build(building_type):
	selection_indictor.visible = !selection_indictor.visible
	var coords =  ground_layer.local_to_map(selection_indictor.position)
	building_layer.set_cell(coords,0,SCENE_COLLECTION, building_type)
	

func on_clicked():
	collecting = true

func on_complete():
	collecting = false
var collecting = false

func resource_destroyed(yielded_resources):
	var resource = get_last_resource()
	if resource:
		if resource.yield_type != InventoryManager.material_types.UNDEFINED:
			InventoryManager.add_material(resource.yield_type, yielded_resources)
			clear_last_resource()
