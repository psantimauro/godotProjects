class_name BuildingButton
extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_texture(texture):
	texture_normal = texture
	self.size = Vector2(10,10)
var button_type
func set_type(type):
	button_type = type
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _pressed() -> void:
	pressed.emit(button_type)
