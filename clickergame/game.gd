extends Node2D



@onready var build_menu = $CanvasLayer/ActionContainer/BuildMenu

@onready var board = $Board


enum buildins {TENT = 5}
var count = 0
var wood =0

func _ready() -> void:
	$Board.generate_game_board()	


	#	count += 1
	
			
const SCENE_COLLECTION = Vector2i.ZERO

				
func destroyed(yielded_resources):
	var resource = board.get_last_resource()#resource_layer.get_cell_scene(board.last_board_click)
	
	if resource:
		if resource.yield_type != InventoryManager.material_types.UNDEFINED:
			InventoryManager.add_material(resource.yield_type, yielded_resources)
			board.clear_last_resource()
	#	match resource.get_meta("type"):
	#		TileManager.tiles.TREE:
	#			wood += yielded_resources
		
		#board.set_cell(last_board_click,0,SCENE_COLLECTION,tiles.GRASS)
		print(yielded_resources)



func _on_build_menu_build_button_clicked(building_type) -> void:
	InventoryManager.build(building_type)
	#	board.build(building_type)
	#	build_menu.toggleBuildMenu(board.selection_indictor.visible)
	#InventoryManager.add_material(resource_type, yielded_resources)
	#wood = wood - 5
