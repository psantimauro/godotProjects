extends Node2D

#@onready var build_menu = $CanvasLayer/ActionContainer/BuildMenu
@onready var board = $Board

@onready var game_hud: GameHUD = $GameHUD

func _hax():
	InventoryManager.unlock_building(InventoryManager.building_types.TENT)	
	InventoryManager.unlock_tool(InventoryManager.tool_types.AXE)
	InventoryManager.add_material(InventoryManager.material_types.HIDE, 2)
	InventoryManager.add_material(InventoryManager.material_types.WOOD, 2)
	
	JobTypeManager.unlock_job(JobTypeManager.TENT_WOOD_CREATE_JOB)
	JobTypeManager.unlock_job(JobTypeManager.TENT_MEAT_CREATE_JOB)
	JobTypeManager.unlock_job(JobTypeManager.TENT_HIDE_CREATE_JOB)
func _ready():
	await game_hud
	await board

	Globals.item_picked_up.connect(pickup)
	Globals.empty_tile_selected.connect(_on_empty_tile_selected)
	Globals.resource_clicked.connect(_on_resource_click)

	game_hud.action_container.build_menu.build_button_clicked.connect(_on_build_menu_build_button_clicked)
	_hax()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("close"):
		Globals.clear_selection.emit()
		game_hud.action_container.hide_kids()

func destroyed(yielded_resources):
	
	board.resource_destroyed(yielded_resources)

func pickup(_type):
	print("pickedup ")

func selected(building):
	game_hud.action_container.build_menu.visible = false
	game_hud.action_container.building_menu.visible = true
	game_hud.action_container.building_menu.building = building
	print("selected building")

func _on_build_menu_build_button_clicked(building_type) -> void:
	InventoryManager.build(building_type)

func _on_empty_tile_selected(_selected_position):
	game_hud.action_container.building_menu.visible = false
	game_hud.action_container.build_menu.visible = board.selection_indictor.visible
	
func _on_resource_click():
	game_hud.action_container.building_menu.visible = false
