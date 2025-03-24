class_name Trade
extends Control

@onready var trade_container: VBoxContainer = $TradeContainer

@export var trade_arrow = preload("res://3rd Party/assets/icons/arrowRight.png")
@export var trade_arrow_size = 50
@export var button_texture: Texture = trade_arrow

func add_trade(trade:base_trade_resource):
	add_trade_button(trade)

func add_trade_button(trade:base_trade_resource):		
	var texture
	var lamba

	if trade is material_trade_resource:
		var result_stack = trade.to_material_stack
		texture = Globals.resize_texture(trade_arrow_size, InventoryManager.get_resource_from_material_type(result_stack.material_type).texture)
		lamba= func():
			if InventoryManager.has_material_stack(trade.from_material_stack):
				InventoryManager.remove_material_stack(trade.from_material_stack)
				InventoryManager.add_material_stack(trade.to_material_stack)
	elif trade is tool_trade_resource:
		var result_tool = trade.to_tool
		texture = Globals.resize_texture(trade_arrow_size, result_tool.texture)
		lamba = func():
			if InventoryManager.has_material_stack(trade.from_material_stack):
				InventoryManager.remove_material_stack(trade.from_material_stack)
				ToolManager.unlock_tool(trade.to_tool.res_type)

	if texture != null && lamba != null:
		var container = PanelContainer.new()
		container.size_flags_vertical = Control.SIZE_EXPAND_FILL
		container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var trade_button = Button.new()
		trade_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		trade_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		container.add_child(trade_button)
		
		var hbox_container = HBoxContainer.new()
		hbox_container.mouse_filter = Control.MOUSE_FILTER_PASS
		var from_image = TextureRect.new()
		var image = InventoryManager.get_resource_from_material_type(trade.from_material_stack.material_type).texture
		from_image.texture = Globals.resize_texture(trade_arrow_size,image)
		hbox_container.add_child(from_image)
		
		var arrow_image = TextureRect.new()
		arrow_image.texture = Globals.resize_texture(trade_arrow_size, trade_arrow)
		hbox_container.add_child(arrow_image)

		trade_button.connect("pressed", lamba)
		var to_image = TextureRect.new()
		to_image.texture = texture
		hbox_container.add_child(to_image)
		container.mouse_filter = Control.MOUSE_FILTER_PASS
		container.add_child(hbox_container)
		trade_container.add_child(container)
