class_name GenerateMaterialJob
extends Node

@export var job_resource: material_create_job 
var timer: Timer 

func _ready() -> void:
	if job_resource != null:
		var type_name = str(InventoryManager.material_types.keys()[job_resource.job_result.material_type]).to_lower()
		self.name = "Generate " +type_name + " job"
		timer = Timer.new()
		timer.timeout.connect(_on_timer_timeout)
		add_child(timer)
	
func start_job() -> void:
	timer.start(job_resource.job_speed)

func stop_job():
	timer.stop()
	
func _on_timer_timeout() -> void:
	InventoryManager.add_material(job_resource.job_result.material_type,job_resource.job_result.material_amount)
