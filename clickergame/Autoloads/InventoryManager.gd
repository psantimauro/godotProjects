extends Node

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
func has_material(name: String, amount: int) -> bool:
	var stack = material_stack.new()
	stack.material_type =  Globals.get_type_from_name(name, material_types)
	stack.material_amount = amount
	return has_material_stack(stack)
	
func has_material_stack(stack: material_stack) -> bool:
	return (Globals.haz(materials_dict, stack.material_type) && (materials_dict[stack.material_type].current_amount >= stack.material_amount))
	
func add_material(type:material_types, amount: int):
	if !(type == null or type == material_types.UNDEFINED):
		if !Globals.haz(materials_dict, type):
			materials_dict[type] = get_resource_from_material_type(type)
			new_material_unlocked.emit(materials_dict[type])
			
		var item:material_resource = materials_dict[type]
		item.current_amount += amount
		total_materials += amount
		materials_dict[type] = item
		material_amount_updated.emit(type,  item.current_amount)
func  remove_material_stack(stack: material_stack):
	remove_material(stack.material_type, stack.material_amount)

func remove_material(type:material_types, amount: int):
	var item:material_resource = materials_dict[type]
	item.current_amount -= amount
	total_materials -= amount
	materials_dict[type] = item
	material_amount_updated.emit(type,  item.current_amount)
