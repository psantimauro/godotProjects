extends Node2D

@onready var build_menu = $CanvasLayer/ActionContainer/BuildMenu
@onready var board = $Board

func _ready():
	GlobalSignals.item_picked_up.connect(pickup)
	
	#		"on_pickup":
	#		child.on_pickup.connect(($"../..").pickup)
func destroyed(yielded_resources):
	var resource = board.get_last_resource()
	if resource:
		if resource.yield_type != InventoryManager.material_types.UNDEFINED:
			InventoryManager.add_material(resource.yield_type, yielded_resources)
			board.clear_last_resource()

func pickup(_type):
	InventoryManager.unlock_tool(InventoryManager.tool_types.AXE)
	InventoryManager.add_material(InventoryManager.material_types.HIDE, 2)

func selected():
	print("selected building")

func _on_build_menu_build_button_clicked(building_type) -> void:
	InventoryManager.build(building_type)
