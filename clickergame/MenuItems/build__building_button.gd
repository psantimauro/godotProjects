class_name BuildBuildingButton
extends TextureButton

@export var buildingtype: BuildingManager.building_types
	
func update_building_info(type = buildingtype):
		buildingtype = type
		var building_res:building_resource = BuildingManager.get_resource_from_building_type(buildingtype)
		set_texture(building_res.texture)
		set_type(buildingtype)
		name = building_res.res_name
		var requirements = self.get_node("RequirementsContainer/Requirements")
		if requirements:
			for c in requirements.get_children():
				c.queue_free()

			var label = Label.new()
			label.text = "Requirements"
			requirements.add_child(label)
			for rq in building_res.requirements:
				var requirement = HBoxContainer.new()
				var needed = rq.material_amount
				label = Label.new()
				label.text = str(needed)
				
				requirement.add_child(label)
			
				var icon = TextureRect.new()
				var texture = InventoryManager.get_resource_from_material_type(rq.material_type).texture
				texture = Globals.resize_texture(50, texture)
				icon.texture = texture
				requirement.add_child(icon)
				requirements.add_child(requirement)

func _ready() -> void:
	var panel = PanelContainer.new()
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.name ="RequirementsContainer"
	
	var req = VBoxContainer.new()
	req.name = "Requirements"
	panel.add_child(req)

	add_child(panel)


func set_texture(texture):
	texture_normal = texture
	self.size = Vector2(10,10)
var button_type
func set_type(type):
	button_type = type

func _pressed() -> void:
	pressed.emit(button_type)
