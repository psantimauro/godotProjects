extends Node

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

func has_tool(type:tool_types) -> bool:
	var tool = get_resource_from_tool_type(type)
	return (tools_dict.has(type) or type == 0)

func unlock_tool(type: tool_types):
	var tool = get_resource_from_tool_type(type)
	if !tools_dict.has(type):
		tool_unlocked.emit(tool)
	tools_dict[type] = tool

func get_tool_stregth(type: tool_types) -> float:
	if tools_dict.has(type):
		var tool = tools_dict[type]
		return tool.strength
	return 0.0

func use_tool(type: tool_types):
	var tool = tools_dict[type]
	tool.strength += 0.001
	tool_strength_changed.emit(type, tool.strength)
