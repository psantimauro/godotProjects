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

func generate_game_board():
	#spawn board
	var x_min = -x_size
	var y_min = -y_size
	for x in range (x_min, x_size):
		for y in range(y_min, y_size):
			var cords = (Vector2i(x,y))
			$GroundLayer.set_cell(cords,0,SCENE_COLLECTION,TileManager.tiles.GRASS)
			var dice = randi_range(1,6) 
			if dice == TileManager.tiles.TREE:
				$ResourceLayer.set_cell(cords,0,SCENE_COLLECTION,TileManager.tiles.TREE)
			elif dice == TileManager.tiles.ROCK:
				$ResourceLayer.set_cell(cords,0,SCENE_COLLECTION,TileManager.tiles.ROCK)
	$Camera2D.move_to( ground_layer.map_to_local(Vector2(x_size, y_size)))

func get_last_resource():
	get_resource_at_position(last_board_click)
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
	
func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("click")):
		if(event is InputEventMouse):
			InventoryManager.unlock_tool(InventoryManager.tool_types.AXE)
	
			var board_local_click = ground_layer.make_input_local(event)
			var board_position = ground_layer.local_to_map(board_local_click.position)
			var global_map_postiion_from_click_position = ground_layer.map_to_local(board_position)
			last_board_click = Vector2i(board_position)
			
						
			var resource = resource_layer.get_cell_scene(last_board_click)
			var build = building_layer.get_cell_scene(last_board_click)
			if  resource:
				$Camera2D.move_to(global_map_postiion_from_click_position)
				if resource.get_meta("type") > 2:
					resource.click()
			elif build:
				$Camera2D.move_to(global_map_postiion_from_click_position)
				pass
			else:
				selection_indictor.position = global_map_postiion_from_click_position
				if !selection_indictor.visible:
					$Camera2D.move_to(selection_indictor.position)
				selection_indictor.set_meta("board_position", board_position)
				selection_indictor.visible = !selection_indictor.visible
				get_parent().build_menu.toggleBuildMenu(selection_indictor.visible)
				
				
				print("build pos: " + str(last_board_click))

func _ready() -> void:
	InventoryManager.building_built.connect(_on_building_build)
