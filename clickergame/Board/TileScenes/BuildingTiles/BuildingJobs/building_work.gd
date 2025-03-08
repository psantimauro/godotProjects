class_name BuildingWork
extends Control

@onready var jobs_container: BuildingJobController = $JobsContainer
@onready var work_buttons_container: VBoxContainer = $VBoxContainer
@onready var progress_bar: TimerProgressBar = $"../ProgressBar"

var button_group: ButtonGroup = ButtonGroup.new()
func _on_button_press(job):
	progress_bar.texture = InventoryManager.get_resource_from_material_type(job.job_result.material_type).texture
	progress_bar.power_multipler = job.job_speed
	jobs_container.add_job(job, progress_bar)
	Globals.clear_selection.emit()


func add_job(job):
	add_job_button(job)

func add_job_button(job:material_create_job):
	var mat_name:String =  InventoryManager.material_types.keys()[job.job_result.material_type]
	var button_name = str(mat_name + "Button")
	var button_exists = false
	for item in work_buttons_container.get_children():
		if !(item is Label) and item.name == button_name:
			button_exists = true
	if !button_exists:
		var new_button = Button.new()
		new_button.name = button_name
		new_button.text =  job.res_name
		new_button.toggle_mode = true
		new_button.button_group = button_group
		new_button.pressed.connect(_on_button_press.bind(job))

		work_buttons_container.add_child(new_button)
