extends Node2D

signal selected
@export var group_type = TileManager.tile_types.BUILDING
@export var type = BuildingManager.building_types.TIPI
@export var button_size = 75

const TO_MEAT = preload("res://Resources/trade_resources/to_meat.tres")
const TO_STONE = preload("res://Resources/trade_resources/to_stone.tres")
const TO_WOOD = preload("res://Resources/trade_resources/to_wood.tres")
const TRADE_PICKAXE = preload("res://Resources/trade_resources/trade_pickaxe.tres")

@onready var trade: Trade = $TipiInterfaceItems/Trade
@onready var despawn_timer: Timer = $DespawnTimer

func _ready():
	add_to_group(Utilities.get_name_from_type(group_type, TileManager.tile_types))
	var has_items = []
	var avail_items = [TO_MEAT, TO_STONE, TO_WOOD]
	avail_items.shuffle()
	has_items.append(avail_items[0])
	has_items.append(avail_items[1])
	
	if !ToolManager.has_tool(ToolManager.tool_types.PICKAXE):
		has_items.append(TRADE_PICKAXE)
	else:
		has_items.append(avail_items[2])

	for item in has_items:
		trade.add_trade_button(item)

func assist_building(amount):
	pass

func click():
	despawn_timer.start()
	selected.emit(self)

func generate_building_action_menu():
	var action_menu = HBoxContainer.new()
	
	for item in %TipiInterfaceItems.get_children():
		var button_container = VBoxContainer.new()
		button_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
		button_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var new_label = Label.new()
		new_label.text = item.name
		button_container.add_child(new_label)
		
		var new_btn = TextureButton.new()
		new_btn.name = item.name + "Button"
		new_btn.texture_normal = Utilities.resize_texture(button_size, item.button_texture)
		var emit_self_lambda = func():
			GameEvents.display_item.emit(item)
			action_menu.queue_free()
		new_btn.pressed.connect(emit_self_lambda)
		button_container.add_child(new_btn)
		action_menu.add_child(button_container)
	return action_menu
	

func _on_despawn_timer_timeout() -> void:
	var node = %TipiInterfaceItems.get_child(0)
	if node == null:
		despawn_timer.start()
	else:
		GameEvents.display_message_with_title.emit("The trader has packed up and left.", "Trader left")
		self.queue_free()
