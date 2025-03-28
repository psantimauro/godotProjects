extends Node2D

@onready var board = $Board
@onready var game_hud: GameHUD = $GameHUD

func _hax():
	BuildingManager.unlock_building(BuildingManager.building_types.CAMPFIRE)	
#	BuildingManager.unlock_building(BuildingManager.building_types.TENT)	
#	BuildingManager.unlock_building(BuildingManager.building_types.LOGCABIN)	
	ToolManager.unlock_tool(ToolManager.tool_types.AXE)
#	ToolManager.unlock_tool(ToolManager.tool_types.PICKAXE)
	
#	InventoryManager.add_material(InventoryManager.material_types.HIDE, 100)
#	InventoryManager.add_material(InventoryManager.material_types.WOOD, 100)
#	InventoryManager.add_material(InventoryManager.material_types.MEAT, 100)
#	InventoryManager.add_material(InventoryManager.material_types.STONE, 100)
	
func init_quests():
	for quest in QuestManager.firstquest_res_array:
		QuestManager.add_quest(quest.instantiate())

func show_intro_message():
	var title = "Welcome to Boom or Bust: Idle Goes West!"
	var message = "Use WASD or Arrow keys to move.

 Your items and materials are displayed in the top left. Quests are on the right.

Click empty tiles to access the build menu.  

If you have the right tool, you can click a resource, to harvest it.
"
	Globals.display_message_with_title.emit(message, title)
	
func _ready():
	await game_hud
	await board
	Globals.item_picked_up.connect(pickup)
	Globals.empty_tile_selected.connect(_on_empty_tile_selected)
	Globals.resource_clicked.connect(_on_resource_click)
	game_hud.action_container.build_menu.build_button_clicked.connect(_on_build_menu_build_button_clicked)
	init_quests()
	show_intro_message()
	_hax()

func pickup(_type):
	InventoryManager.add_material(InventoryManager.material_types.HIDE, 2)
	print("pickedup")

func selected(building):
	game_hud.action_container.hide_kids()
	game_hud.action_container.display_building_menu(building.generate_building_action_menu())
	print("selected building")

func _on_build_menu_build_button_clicked(building_type) -> void:
	BuildingManager.build(building_type)

func _on_empty_tile_selected(_selected_position):
	game_hud.action_container.hide_kids()
	game_hud.action_container.build_menu.visible = true
	print("selected empty tile")
	
func _on_resource_click():
	game_hud.action_container.hide_kids()
	print("clicked resource")
