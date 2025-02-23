extends Node


func haz(dict, type) -> bool:
	return dict.has(type)
## MATERIALS SECTION
signal material_amount_updated
signal new_material_unlocked

enum material_types {UNDEFINED, WOOD, STONE, HIDE, MEAT}

const WOOD = preload("res://Resources/material_resources/wood.tres")
const MEAT = preload("res://Resources/material_resources/meat.tres")
const HIDE = preload("res://Resources/material_resources/hide.tres")
const STONE = preload("res://Resources/material_resources/stone.tres")
func get_resource_from_material_type(type):
	match type:
		WOOD.res_type:
			return WOOD
		MEAT.res_type:
			return MEAT
		HIDE.res_type:
			return HIDE
		STONE.res_type:
			return STONE

var materials_dict = {}
var total_materials = 0
func add_material(type:material_types, amount: int):
	
	if !haz(materials_dict, type):
		materials_dict[type] = get_resource_from_material_type(type)
		new_material_unlocked.emit(materials_dict[type])
		
	var item:material_resource = materials_dict[type]
	item.current_amount += amount
	total_materials += amount
	material_amount_updated.emit(type,  item.current_amount)

##BUILDINGS SECTION
signal building_built
enum build_types {UNDEFINED = -1, TENT = 5}

var builds_dict = {}
func build(build_type: build_types):
	#TODO Check if we have all the requirements.
	if !haz(builds_dict,build_type):
		print("building: " + str(build_type))
		building_built.emit(build_type)

##TOOLS SECTION
enum tool_types {UNDEFINED = -1, AXE =1, PICKAXE =2, HAMMER, KNIFE}
signal tool_unlocked

const AXE = preload("res://Tools/Axe.tres")
const PICKAXE = preload("res://Tools/Pickaxe.tres")

func get_resource_from_tool_type(type) -> Resource:
	match type:
		AXE.res_type:
			return AXE
		PICKAXE.res_type:
			return PICKAXE
	return null
	
var tools_dict = {}

func has_tool(type:InventoryManager.tool_types) -> bool:
	var tool = get_resource_from_tool_type(type)
	return tools_dict.has(type)

func unlock_tool(type: InventoryManager.tool_types, quality =1):
	var tool = get_resource_from_tool_type(type)
	tool.stregth = quality
	if !tools_dict.has(type):
		tool_unlocked.emit(tool)
	tools_dict[type] = tool
