extends Node

enum tool_types {UNDEFINED = -1, AXE = 1, PICKAXE = 2, HAMMER, KNIFE}
enum tool_usages {LUMBERJACKING, MINING, HUNTING, BUILDING}


const AXE = preload("res://Resources/tool_resources/Axe.tres")
const PICKAXE = preload("res://Resources/tool_resources/Pickaxe.tres")
const KNIFE = preload("res://Resources/tool_resources/Knife.tres")

func get_resource_from_tool_type(type) -> tool_resource:
	match type:
		AXE.res_type:
			return AXE
		PICKAXE.res_type:
			return PICKAXE
		KNIFE.res_type:
			return KNIFE
	return null
	
var tools_dict = {}

func has_tool(type: tool_types) -> bool:
	#var tool = get_resource_from_tool_type(type)
	return (tools_dict.has(type) or type == 0)

func unlock_tool(type: tool_types):
	var tool = get_resource_from_tool_type(type)
	if !tools_dict.has(type):
		GameEvents.tool_unlocked.emit(tool )
	tools_dict[type] = tool

func get_tool_stregth(type: tool_types) -> float:
	if tools_dict.has(type):
		var tool = tools_dict[type]
		return tool.strength
	return 0.0

func use_tool(type: tool_types):
	var tool = tools_dict[type]
	tool.strength += 0.001
	GameEvents.tool_strength_changed.emit(type, tool.strength)

func get_hunting_tool():
	return get_best_tool(tool_usages.HUNTING)
func get_lumberjacking_tool():
	return get_best_tool(tool_usages.LUMBERJACKING)
func get_mining_tool():
	return get_best_tool(tool_usages.MINING)
func get_building_tool():
	return get_best_tool(tool_usages.BUILDING)
	
func get_best_tool(type: tool_usages, best_tool = null):
	for key in tools_dict.keys():
		var tool: tool_resource = tools_dict[key]
		if tool != null && tool.usage == type:
			if best_tool == null:
				best_tool = tool
			elif tool.strength > best_tool.strength:
				best_tool = tool
	return best_tool
