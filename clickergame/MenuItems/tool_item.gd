class_name ToolItem
extends PanelContainer
@onready var _texture_rect: TextureRect = $TextureRect

@export var texture:Texture :
	set(txtr):
		_texture_rect.texture = txtr
		
