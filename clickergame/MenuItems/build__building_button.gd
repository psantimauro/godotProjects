class_name BuildBuildingButton
extends Button

@export var buildingtype: BuildingManager.building_types

@onready var building_requirements_container: VBoxContainer = %BuildingRequirementsContainer

@onready var building_type_name_label: Label = %BuildingTypeNameLabel
func update_building_info(type = buildingtype):
		buildingtype = type
		var building_res:building_resource = BuildingManager.get_resource_from_building_type(buildingtype)
		set_texture(building_res.texture)
		name = building_res.res_name
		building_type_name_label.text = name
		if building_requirements_container:
			for rq in building_res.requirements:
				var requirement_container = HBoxContainer.new()
				var icon = TextureRect.new()
				var texture = InventoryManager.get_resource_from_material_type(rq.material_type).texture
				texture = Globals.resize_texture(25, texture)
				icon.texture = texture
				requirement_container.add_child(icon)
				
				var needed = rq.material_amount
				var label = Label.new()
				label.text = str(needed)				
				requirement_container.add_child(label)
			
				requirement_container.name = Globals.get_name_from_type(rq.material_type, InventoryManager.material_types)
				building_requirements_container.add_child(requirement_container)

func animate_missing_resource(material_name):
	for item in building_requirements_container.get_children():
		if item.name == material_name:
			var tween = item.create_tween()
			#tween.tween_property(item, "modulate", Color.RED, 1).set_trans(Tween.TRANS_SINE)
			var original_pos = item.position
			var  shake = Vector2(5,0)
			var duration = 0.1
			var count =10
			for i in count:
				var direction = 1
				if i%2 == 1: 
					direction *= -1
				var pos = item.position +(shake * direction)
				tween.tween_property(item, "position", pos,duration)
			item.position = original_pos
@onready var texture_rect: TextureRect = %TextureRect
func set_texture(texture):
	texture_rect.texture = texture

func _on_pressed() -> void:
	pressed.emit(buildingtype)
