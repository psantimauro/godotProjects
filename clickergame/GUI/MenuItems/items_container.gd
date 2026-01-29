extends PanelContainer

@onready var tools: VBoxContainer = $VBoxContainer/Tools
@onready var materials: VBoxContainer = $VBoxContainer/Materials
@onready var total_materials: Label = $VBoxContainer/Materials/TotalMaterials

@onready var quest_counter: Label = $"VBoxContainer/CounterContainer/Quest Counter"

func _ready() -> void:
	GameEvents.material_amount_updated.connect(_on_material_amount_updated)
	GameEvents.new_material_unlocked.connect(_on_material_unlocked)
	GameEvents.tool_unlocked.connect(_on_tool_unlocked)

func _on_material_amount_updated(type: InventoryManager.material_types, amount):
	show()
	total_materials.visible = true
	total_materials.text = "Materials: " + str(InventoryManager.total_materials)
	var mat: material_resource = InventoryManager.materials_dict[type]
	if mat:
		if materials.has_node(mat.res_name):
			var item = materials.get_node(mat.res_name)
			if item:
				var i = mat.current_amount
				item.amount = i
const MATERIAL_ITEM = preload("res://GUI/MenuItems/MaterialItem.tscn")
func _on_material_unlocked(mat: material_resource):
	if mat != null:
		show()
		var item: MaterialItem = MATERIAL_ITEM.instantiate()
		item.name = mat.res_name
		materials.add_child(item)
		item.texture = mat.texture
		item.amount = InventoryManager.materials_dict[mat.res_type]
	
	
const TOOL_ITEM = preload("res://GUI/MenuItems/ToolItem.tscn")
func _on_tool_unlocked(tool: tool_resource):
	show()
	var item = TOOL_ITEM.instantiate()
	tools.add_child(item)
	item.tool_type = tool.res_type
	item.texture = tool.texture
	var value = ToolManager.tool_types.keys()[ tool.res_type]
	item.name = value
#	var new_sprite: TextureRect = TextureRect.new()
	#new_sprite.texture = tool.texture
	#new_sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	#tools.add_child(new_sprite)
