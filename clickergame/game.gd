extends Node2D

#@onready var build_menu = $CanvasLayer/ActionContainer/BuildMenu
@onready var board = $Board

@onready var game_hud: GameHUD = $GameCanvasLayer

func _hax():
	InventoryManager.unlock_building(InventoryManager.build_types.TENT)
	

func _ready():
	GlobalSignals.item_picked_up.connect(pickup)
	GlobalSignals.empty_tile_selected.connect(_on_empty_tile_selected)
	GlobalSignals.resource_clicked.connect(_on_resource_click)
	await game_hud
	game_hud.action_container.build_menu.build_button_clicked.connect(_on_build_menu_build_button_clicked)
	
	_hax()
	

func destroyed(yielded_resources):
	board.resource_destroyed(yielded_resources)


func pickup(_type):
	InventoryManager.unlock_tool(InventoryManager.tool_types.AXE)
	InventoryManager.add_material(InventoryManager.material_types.HIDE, 2)

func selected(building):
	game_hud.action_container.build_menu.visible = false
	game_hud.action_container.building_menu.visible = true
	
	print("selected building")

func _on_build_menu_build_button_clicked(building_type) -> void:
	InventoryManager.build(building_type)

func _on_empty_tile_selected(_selected_position):
	game_hud.action_container.building_menu.visible = false
	game_hud.action_container.build_menu.visible = board.selection_indictor.visible
	
func _on_resource_click():
	game_hud.action_container.building_menu.visible = false
