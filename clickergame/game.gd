extends Node2D

@onready var board = $Board
@onready var game_hud: GameHUD = $GameHUD

func _hax():
	BuildingManager.unlock_building(BuildingManager.building_types.CAMPFIRE)
	
	BuildingManager.unlock_building(BuildingManager.building_types.WELL)
	BuildingManager.unlock_building(BuildingManager.building_types.TENT)
	BuildingManager.unlock_building(BuildingManager.building_types.LOGCABIN)
	
	ToolManager.unlock_tool(ToolManager.tool_types.AXE)
#	ToolManager.unlock_tool(ToolManager.tool_types.PICKAXE)
	
	InventoryManager.add_material(InventoryManager.material_types.HIDE, 9)
	InventoryManager.add_material(InventoryManager.material_types.WOOD, 6)
	InventoryManager.add_material(InventoryManager.material_types.MEAT, 9)
	InventoryManager.add_material(InventoryManager.material_types.STONE, 9)
	
func init_quests():
	for quest in QuestManager.firstquest_res_array:
		var instance = quest.instantiate()
		QuestManager.add_main_quest(instance)

func show_intro_message():
	var title = "Welcome to Idle Goes West!"
	var message = "You are a trapper exploring western america in the young 1800s.
	- Use [WASD] or [Arrow] keys to move the camera.
	- Follow the quests on the right to learn the game and unlock features.
	- Things will become more interactable as you unlock more...
	- Don't forget to click ;)"
	GameEvents.display_message_with_title.emit(message, title)

func _ready():
	await game_hud
	await board
	GameEvents.item_picked_up.connect(_on_item_pickup)
	GameEvents.empty_tile_selected.connect(_on_empty_tile_selected)
	GameEvents.resource_clicked.connect(_on_resource_click)
	GameEvents.building_selected.connect(_on_building_selected)
	game_hud.action_container.build_menu.build_button_clicked.connect(_on_build_menu_build_button_clicked)
	init_quests()
	show_intro_message()
#	_hax()

func _on_item_pickup(item):
	if item.type == ToolManager.tool_types.AXE:
		GameEvents.display_message_with_title.emit("Those pesky trees don't stand a chance", "You unlocked the Axe.")
		ToolManager.unlock_tool(ToolManager.tool_types.AXE)
	elif item.type == ToolManager.tool_types.KNIFE:
		GameEvents.display_message_with_title.emit("Maybe you can stab a deer...?", "Knife Unlocked")
		ToolManager.unlock_tool(ToolManager.tool_types.KNIFE)
	elif item.type == TileManager.tiles.MUSHROOM:
		InventoryManager.add_material(InventoryManager.material_types.HIDE, 2)

func _on_building_selected(building):
	game_hud.action_container.hide_kids()
	game_hud.action_container.display_building_menu(building.generate_building_action_menu())

func _on_build_menu_build_button_clicked(building_type) -> void:
	BuildingManager.build(building_type)

func _on_empty_tile_selected(_selected_position):
	game_hud.action_container.hide_kids()
	game_hud.action_container.display_build_menu()

func _on_resource_click():
	game_hud.action_container.hide_kids()
