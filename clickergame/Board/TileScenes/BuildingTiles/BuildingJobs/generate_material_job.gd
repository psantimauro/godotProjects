class_name GenerateMaterialJob
extends Node

@export var job_resource: material_create_job 
var timer: ClickableProgressBar 
func _ready() -> void:
	if job_resource != null:
		var type_name = str(InventoryManager.material_types.keys()[job_resource.job_result.material_type]).to_lower()
		self.name = "Generate " +type_name + " job"
		timer.done.connect(_on_timer_timeout)
		add_child(timer)
	
func start_job() -> void:
	if can_work_job():
		stop_job()
		timer.run_time = job_resource.job_speed
		timer.start()
	else:
		#TODO inform player they dont have the stuff
		print("mssing tool to do work")

func stop_job():
	timer.stop()
	
func _on_timer_timeout() -> void:
	InventoryManager.add_material(job_resource.job_result.material_type,job_resource.job_result.material_amount)
	start_job()

	
func can_work_job() -> bool:
	return ToolManager.has_tool(job_resource.required_tool) 
