extends PanelContainer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("close"):
		for kid in get_children():
			kid.visible= false
			kid.reparent(old_parent)
		visible = false

var old_parent
func set_item(item):
	old_parent = item.get_parent()
	visible = true
	item.visible = true
	item.reparent(self)
	#add_child(item)
