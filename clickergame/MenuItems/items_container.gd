extends HBoxContainer

func _ready() -> void:
	InventoryManager.material_amount_updated.connect(_on_material_amount_updated)
	InventoryManager.new_material_unlocked.connect(_on_material_unlocked)
	InventoryManager.tool_unlocked.connect(_on_tool_unlocked)
	
func _on_material_amount_updated(type:InventoryManager.material_types, amount):
	
	$Materials/TotalMaterials.text = "Total Materials: " + str(InventoryManager.total_materials)
	
	var mat:material_resource = InventoryManager.materials_dict[type]
	if mat:
		var path = "Materials/" + mat.res_name + "/Label"
		var label = get_node(path)
		label.text = str(mat.current_amount)
	
func _on_material_unlocked(mat: material_resource):
	var node = VFlowContainer.new()
	node.name = mat.res_name
	var image = TextureRect.new()
	image.texture = mat.texture
	node.add_child(image)
	var new_label: Label = Label.new()
	new_label.name =  "Label"
	new_label.text = str(mat.current_amount)
	node.add_child(new_label)
	
	$Materials.add_child(node)

func _on_tool_unlocked(tool: tool_resource):
	var new_sprite: TextureRect = TextureRect.new()
	new_sprite.texture = tool.texture
	
	$Tools.add_child(new_sprite)
