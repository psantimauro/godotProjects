class_name BuildingWork
extends Control

@onready var jobs_container: BuildingJobController = $JobsContainer
@onready var progress_bar: TimerProgressBar = $"../ProgressBar"
@onready var work_buttons_container: VBoxContainer = $VBoxContainer

var button_group: ButtonGroup = ButtonGroup.new()


func _on_button_press(type = InventoryManager.material_types.WOOD, amount = 1):
	var job = material_create_job.new()
	job.job_result = material_stack.new()
	job.job_result.material_type = type
	job.job_result.material_amount = amount
	progress_bar.texture = InventoryManager.get_resource_from_material_type(type).texture
	
	jobs_container.add_job(job, progress_bar)

func add_job(job):
	var mat_job:material_create_job = job
			
	if mat_job != null:
		var mat_name:String =  InventoryManager.material_types.keys()[mat_job.job_result.material_type]
		var button_exists = false
		for item in work_buttons_container.get_children():
			if !(item is Label) and item.name == str(mat_name + "Button"):
				button_exists = true
		if !button_exists:
			var new_button = Button.new()
			new_button.name = str(mat_name + "Button")
			new_button.text =  str("Generate " + mat_name.to_lower())
			new_button.toggle_mode = true
			new_button.button_group = button_group
			new_button.pressed.connect(_on_button_press.bind(mat_job.job_result.material_type, mat_job.job_result.material_amount))
			work_buttons_container.add_child(new_button)
