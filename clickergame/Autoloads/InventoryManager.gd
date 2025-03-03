extends Node


func haz(dict, type) -> bool:
	return dict.has(type)
## MATERIALS SECTION
signal material_amount_updated
signal new_material_unlocked

enum material_types {UNDEFINED = -1, WOOD = 1, STONE = 2, HIDE = 3, MEAT = 4}

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
	if !(type == null or type == material_types.UNDEFINED):
		if !haz(materials_dict, type):
			materials_dict[type] = get_resource_from_material_type(type)
			new_material_unlocked.emit(materials_dict[type])
			
		var item:material_resource = materials_dict[type]
		item.current_amount += amount
		total_materials += amount
		materials_dict[type] = item
		material_amount_updated.emit(type,  item.current_amount)
		
func remove_material(type:material_types, amount: int):
			
	var item:material_resource = materials_dict[type]
	item.current_amount -= amount
	total_materials -= amount
	materials_dict[type] = item
	material_amount_updated.emit(type,  item.current_amount)

##BUILDINGS SECTION
signal building_built
signal building_unlocked
enum building_types {UNDEFINED = -1, TENT = 5}
const TENT = preload("res://Resources/building_resources/tent.tres")

func get_resource_from_building_type(type:building_types) -> building_resource:
	match type:
		building_types.TENT:
			return TENT
	return  null
	
var builds_dict = {}
func build(build_type: building_types):
	var building_res = get_resource_from_building_type(build_type)
	if !haz(builds_dict,build_type) and has_all_resources_to_build(building_res):
		print("building: " + str(build_type))
		for requirement:material_stack in building_res.requirements:
			remove_material(requirement.material_type, requirement.material_amount)
		building_built.emit(build_type)
	else:
		print("dont have build stuffs")
func has_all_resources_to_build(building_res: building_resource) -> bool:
	var has_all = true
	for requirement:material_stack in building_res.requirements:
		var mat = requirement.material_type
		if !materials_dict.has(mat) or materials_dict[mat].current_amount < requirement.material_amount:
			has_all = false
	return has_all

func unlock_building(build_type: building_types):
	building_unlocked.emit(build_type)

##TOOLS SECTION
enum tool_types {UNDEFINED = -1, AXE =1, PICKAXE =2, HAMMER, KNIFE}
signal tool_unlocked
signal tool_strength_changed
const AXE = preload("res://Resources/tool_resources/Axe.tres")
const PICKAXE = preload("res://Resources/tool_resources/Pickaxe.tres")

func get_resource_from_tool_type(type) -> tool_resource:
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

func unlock_tool(type: InventoryManager.tool_types):
	var tool = get_resource_from_tool_type(type)
	if !tools_dict.has(type):
		tool_unlocked.emit(tool)
	tools_dict[type] = tool

func get_tool_stregth(type: InventoryManager.tool_types) -> float:
	if tools_dict.has(type):
		var tool = tools_dict[type]
		return tool.strength
	return 0.0

func use_tool(type: InventoryManager.tool_types):
	var tool = tools_dict[type]
	tool.strength += 0.001
	tool_strength_changed.emit(type, tool.strength)
