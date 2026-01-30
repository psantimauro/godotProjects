class_name Trade
extends Control

@onready var trade_container: VBoxContainer = $TradeContainer

@export var trade_arrow = preload("res://3rd Party/assets/icons/arrowRight.png")
@export var trade_arrow_size = 50
@export var button_texture: Texture = trade_arrow

func add_trade(trade: base_trade_resource):
	add_trade_button(trade)

func add_trade_button(trade: base_trade_resource):
	var texture
	var lamba

	if trade is material_trade_resource:
		var result_stack = trade.to_material_stack
		texture = Utilities.resize_texture(trade_arrow_size, InventoryManager.get_resource_from_material_type(result_stack.material_type).texture)
		lamba = func():
			if InventoryManager.has_material_stack(trade.from_material_stack):
				InventoryManager.remove_material_stack(trade.from_material_stack)
				InventoryManager.add_material_stack(trade.to_material_stack)
			else:
				tween_missing_material(trade)
	elif trade is tool_trade_resource:
		var result_tool = trade.to_tool
		texture = Utilities.resize_texture(trade_arrow_size, result_tool.texture)
		lamba = func():
			if InventoryManager.has_material_stack(trade.from_material_stack):
				InventoryManager.remove_material_stack(trade.from_material_stack)
				ToolManager.unlock_tool(trade.to_tool.res_type)
				self.remove_tool_trade_button(trade)
			else:
				tween_missing_material(trade)

	if texture != null && lamba != null:
		var container = PanelContainer.new()
		container.size_flags_vertical = Control.SIZE_EXPAND_FILL
		container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var trade_button = Button.new()
		trade_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		trade_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		container.name = trade.res_name
		container.add_child(trade_button)
		
		var hbox_container = HBoxContainer.new()
		hbox_container.name = "HBoxContainer"
		hbox_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var from_image = TextureRect.new()
		var image = InventoryManager.get_resource_from_material_type(trade.from_material_stack.material_type).texture
		from_image.texture = Utilities.resize_texture(trade_arrow_size, image)
		from_image.name = "FromImage"
		from_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var from_label = Label.new()
		from_label.text = str(trade.from_material_stack.material_amount)
		from_label.add_theme_color_override("font_color", Color.WHITE)
		from_label.add_theme_color_override("font_outline_color", Color.BLACK)
		from_label.position = Vector2(12, 12)
		from_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		from_image.add_child(from_label)
		hbox_container.add_child(from_image)
		
		var arrow_image = TextureRect.new()
		arrow_image.texture = Utilities.resize_texture(trade_arrow_size, trade_arrow)
		arrow_image.name = "Arrow"
		arrow_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hbox_container.add_child(arrow_image)

		trade_button.connect("pressed", lamba)
		
		var to_image = TextureRect.new()
		to_image.texture = texture
		to_image.name = "ToImage"
		to_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if trade is material_trade_resource:
			var to_label = Label.new()
			to_label.text = str(trade.to_material_stack.material_amount)
			to_label.position = Vector2(12, 12)
			to_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
			to_label.add_theme_color_override("font_color", Color.WHITE)
			to_label.add_theme_color_override("font_outline_color", Color.BLACK)
			to_image.add_child(to_label)
			
		hbox_container.add_child(to_image)
		container.mouse_filter = Control.MOUSE_FILTER_PASS
		container.add_child(hbox_container)
		trade_container.add_child(container)

func remove_tool_trade_button(trade):
	for kid in self.get_child(0).get_children():
		if kid.name == trade.res_name:
			kid.queue_free()

func tween_missing_material(trade):
	for kid in self.get_child(0).get_children():
		if kid.name == trade.res_name:
			var item = kid.get_node("HBoxContainer/FromImage")
			var tween = item.create_tween()
			var original_pos = item.position
			var shake = Vector2(5, 0)
			var duration = 0.1
			var count = 10
			for i in count:
				var direction = 1
				if i % 2 == 1:
					direction *= -1
				var pos = item.position + (shake * direction)
				tween.tween_property(item, "position", pos, duration)
			tween.tween_property(item, "position", original_pos, duration)
