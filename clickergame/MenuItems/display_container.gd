extends PanelContainer

var old_parent
@onready var default_label: Label = $DefaultLabel

func _ready() -> void:
	Globals.empty_tile_selected.connect(_outside_click)
	Globals.resource_clicked.connect(rechild)
	Globals.clear_selection.connect(rechild)
	BuildingManager.building_unlocked.connect(_on_building_unlocked)
	BuildingManager.job_unlocked.connect(_on_job_unlocked)
	BuildingManager.tech_unlocked.connect(_on_tech_unlocked)
func _outside_click(any):
	if old_parent != null:
		rechild()
func _on_building_unlocked(type):
	var name = Globals.get_name_from_type(type, BuildingManager.building_types)
	var text = "Unlocked " + name
	update_display(text)

func update_display(text):
	default_label.text = text
	default_label.show()
	show()	

func _on_job_unlocked(job: base_job_resource, building_type):
	var text = "Unlocked " + job.res_name + " for " + Globals.get_name_from_type(building_type, BuildingManager.building_types)
	update_display(text)

func _on_tech_unlocked(tech: base_tech_resource, building_type):
	var text = "Unlocked " + tech.res_name + " for " + Globals.get_name_from_type(building_type, BuildingManager.building_types)
	update_display(text)

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
