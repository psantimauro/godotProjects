extends PanelContainer

@onready var main_display_container: VBoxContainer = %MainDisplayContainer
@onready var close_display_button: TextureButton = %CloseDisplayButton
@onready var main_display_label: Label = %MainDisplayLabel
@onready var display_title_label: Label = %DisplayTitleLabel

@export var disable_popups: bool = false

func _ready() -> void:
	GameEvents.empty_tile_selected.connect(_outside_click)
	GameEvents.resource_clicked.connect(close)
	GameEvents.clear_selection.connect(close)
	GameEvents.display_message_with_title.connect(_on_display_message_with_title)
	GameEvents.display_item.connect(_on_display_item)
	
	GameEvents.building_unlocked.connect(_on_building_unlocked)
	GameEvents.job_unlocked.connect(_on_job_unlocked)
	GameEvents.tech_unlocked.connect(_on_tech_unlocked)

var old_parent
var display_list = []
func update_display(text: String, header_text = ""):
	if disable_popups:
		return
		
	if display_list.size() > 0:
		var item = display_list[0]
		if item is Array:
			display_title_label.text = item[1]
			main_display_label.text = item[0]
			main_display_label.show()
			show()
	else:
		display_title_label.text = header_text
		main_display_label.text = text
		main_display_label.show()
		show()
	display_list.append([text, header_text])

func reparent_existing():
	if old_parent != null:
		for kid in main_display_container.get_children():
			kid.visible = false
			if !(kid == main_display_label):
				kid.reparent(old_parent)
		old_parent = null

func set_item(item):
	if display_list.size() > 0:
		var next_item = display_list[0]
		if next_item is Container:
			visible = true
			next_item.reparent(main_display_container)
			display_title_label.text = next_item.name
			next_item.visible = true
	else:
		old_parent = item.get_parent()
		visible = true
		item.reparent(main_display_container)
		display_title_label.text = item.name
		item.visible = true
	display_list.append(item)

func close():
	self.hide()
	var next_item = null
	if display_list.size() > 0:
		if (display_list[0] is Container):
			reparent_existing()
		display_list.remove_at(0) # remove the first entry from the list, this should be what was just closed
		
		if display_list.size() > 0:
			next_item = display_list[0]
			await get_tree().create_timer(0.25).timeout
			if next_item is Array:
				update_display(next_item[0], next_item[1])
			elif next_item != null:
				set_item(next_item)
			self.show()
			display_list.remove_at(0) # update will add itself to the list, so remove i

	else:
		main_display_label.text = ""
		main_display_label.hide()
		display_title_label.text = ""
func _on_close_display_button_pressed() -> void:
	close()
func _outside_click(any):
	close()

func _on_building_unlocked(type):
	var name = Utilities.get_name_from_type(type, BuildingManager.building_types)
	var text = name + " is now available in the build menu."
	update_display(text, "New Building Unlocked!")

func _on_job_unlocked(job: base_job_resource, building_type):
	var text = job.res_name + " has been unlocked for " + Utilities.get_name_from_type(building_type, BuildingManager.building_types)
	update_display(text, "New Job Unlocked!")

func _on_tech_unlocked(tech: base_tech_resource, building_type):
	var text = "Unlocked " + tech.res_name + " for " + Utilities.get_name_from_type(building_type, BuildingManager.building_types)
	update_display(text, "New Research Unlocked!")
func _on_display_message_with_title(msg, title):
	update_display(msg, title)

func _on_display_item(item):
	set_item(item)
