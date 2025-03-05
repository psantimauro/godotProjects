class_name UnlockJobTech
extends Node

@export var tech_resource: job_unlock_tech 
var timer: TimerProgressBar 
func _ready() -> void:
	if tech_resource != null:
		#var type_name = str(InventoryManager.material_types.keys()[job_resource.job_result.material_type]).to_lower()
		self.name = "Research " + tech_resource.unlocked_job.resource_name
		timer.done.connect(_on_timer_timeout)
		add_child(timer)
	
func start_research() -> void:
	stop_research()
	timer.timer_duration = tech_resource.research_speed
	timer.start()

func stop_research():
	timer.stop()
	
func _on_timer_timeout() -> void:
	JobTypeManager.unlock_job(tech_resource.unlocked_job)
