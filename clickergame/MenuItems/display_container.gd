extends PanelContainer

var old_parent

func _ready() -> void:
	#TODO clean up so this doesnt happen all the time
	Globals.empty_tile_selected.connect(_outside_click)
	Globals.resource_clicked.connect(rechild)
	Globals.clear_selection.connect(rechild)
	
func _outside_click(any):
	if old_parent != null:
		rechild()

func rechild(run = self.visible):
	if run:
		for kid in get_children():
			if kid.name != "CloseDisplayButton":
				kid.visible= false
				kid.reparent(old_parent)
		visible = false
		old_parent = null

func set_item(item):
	rechild()
	old_parent = item.get_parent()
	visible = true
	item.visible = true
	item.reparent(self)

func close():
	rechild()
	self.hide()
func _on_close_display_button_pressed() -> void:
	close()
