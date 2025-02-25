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
const TENT = preload("res://Resources/building_resources/tent.tres")



func get_resource_from_building_type(type:build_types) -> building_resource:
	match type:
		build_types.TENT:
			return TENT
	return  null
	
var builds_dict = {}
func build(build_type: build_types):
	var building_res = get_resource_from_building_type(build_type)
	if !haz(builds_dict,build_type) and has_all_resources_to_build(building_res):
		print("building: " + str(build_type))
		for requirement:recipe_item_resource in building_res.requirements:
			materials_dict[requirement.material_type.res_type].current_amount = materials_dict[requirement.material_type.res_type].current_amount - requirement.material_amount
		building_built.emit(build_type)
	else:
		print("dont have build stuffs")
func has_all_resources_to_build(building_res: building_resource) -> bool:
	var has_all = true
	for requirement:recipe_item_resource in building_res.requirements:
		var mat = requirement.material_type.res_type
		if !materials_dict.has(mat) or materials_dict[mat].current_amount < requirement.material_amount:
			has_all = false
	return has_all
	
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
