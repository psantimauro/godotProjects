extends HBoxContainer

func _ready() -> void:
	InventoryManager.material_amount_updated.connect(_on_material_amount_updated)
	InventoryManager.new_material_unlocked.connect(_on_material_unlocked)
	InventoryManager.tool_unlocked.connect(_on_tool_unlocked)
	
func _on_material_amount_updated(type:InventoryManager.material_types, amount):
	
	$Materials/TotalMaterials.text = "Total Materials: " + str(InventoryManager.total_materials)
	
	var mat = InventoryManager.materials_dict[type]
	if mat:
		var path = "Materials/" + mat.res_name
		var label = get_node(path)
		label.text = mat.res_name + ": "+ str(mat.current_amount)
	
func _on_material_unlocked(mat: material_resource):
	var new_label: Label = Label.new()
	new_label.name = mat.res_name
	new_label.text = new_label.name
	$Materials.add_child(new_label)

func _on_tool_unlocked(tool: tool_resource):
	var new_sprite: TextureRect = TextureRect.new()
	new_sprite.texture = tool.texture
	
	$Tools.add_child(new_sprite)
