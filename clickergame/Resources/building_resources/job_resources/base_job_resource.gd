class_name base_job_resource
extends base_resource

@export var required_tool: ToolManager.tool_types = ToolManager.tool_types.UNDEFINED
@export var type: BuildingManager.job_types = BuildingManager.job_types.UNDEFINED
@export var job_level = 1
@export var job_speed: float 
