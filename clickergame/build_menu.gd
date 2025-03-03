class_name BuildMenu
extends VFlowContainer

signal build_button_clicked
@onready var build_button_container: HBoxContainer = $BuildButton/VBoxContainer

func _ready() -> void:
	InventoryManager.building_built.connect(_on_building_built)
	InventoryManager.building_unlocked.connect(_on_building_unlocked)
	Globals.connect("empty_tile_selected",toggleBuildMenu)

func _on_building_unlocked(building_type: InventoryManager.building_types):
	var building_button:BuildingButton = BuildingButton.new()
	var building_res:building_resource = InventoryManager.get_resource_from_building_type(building_type)
	for rq in building_res.requirements:
		var needed = rq.material_amount
		var label = Label.new()
		label.text = str(needed)
		build_button_container.add_child(label)
		
		var icon = TextureRect.new()
		var texture = InventoryManager.get_resource_from_material_type(rq.material_type).texture
		texture = Globals.resize_texture(50, texture)
		icon.texture = texture
		build_button_container.add_child(icon)
		
	building_button.set_texture(building_res.texture)
	building_button.set_type(building_type)
	building_button.name = building_res.res_name
	building_button.visible = false
	building_button.pressed.connect(_on_button_pressed)
	add_child(building_button)

func _on_building_built(_build_type):
	toggleBuildMenu(null, false)

func toggleBuildMenu(_location = null, visible = true):
	var vis = visible
	self.visible = vis
	for kid in get_children():
		kid.visible = vis

func _on_button_pressed(type) -> void:
	build_button_clicked.emit(type) #0 is the type for tent
