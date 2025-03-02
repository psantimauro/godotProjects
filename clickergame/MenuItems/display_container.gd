extends PanelContainer

func _ready() -> void:
	GlobalSignals.empty_tile_selected.connect(_outside_click)
	GlobalSignals.resource_clicked.connect(rechild)
	
func _outside_click(any):
	if old_parent != null:
		rechild()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("close"):
		rechild()
		
func rechild():
	for kid in get_children():
		kid.visible= false
		kid.reparent(old_parent)
		
	visible = false
	old_parent = null
	
var old_parent
func set_item(item):
	rechild()
	old_parent = item.get_parent()
	visible = true
	item.visible = true
	item.reparent(self)
	#add_child(item)
