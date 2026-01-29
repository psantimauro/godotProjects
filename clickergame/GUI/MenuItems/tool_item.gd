class_name ToolItem
extends PanelContainer
@onready var _texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

@export var tool_type: ToolManager.tool_types

@export var texture: Texture:
	set(txtr):
		_texture_rect.texture = txtr
		
func _on_tool_level(type, value):
	if type == tool_type:
		label.text = str("%1.3f" % value)

func _ready() -> void:
	GameEvents.tool_strength_changed.connect(_on_tool_level)
