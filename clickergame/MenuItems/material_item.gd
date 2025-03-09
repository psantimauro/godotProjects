class_name MaterialItem
extends Control

@onready var _texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var _label: Label = $HBoxContainer/Label


@export var texture:Texture :
	set(txtr):
		_texture_rect.texture = txtr
@export var amount = 0:
	set(amt):
		_label.text = str(amt)
