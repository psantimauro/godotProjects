class_name BuildingWork
extends Control

@onready var work_buttons_container: VBoxContainer = $VBoxContainer
@onready var progress_bar: TimerProgressBar = $"../ProgressBar"

@onready var building: BuildingBase = $".."

var button_group: ButtonGroup = ButtonGroup.new()
func _on_button_press(job):
	building.start_job(job)
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
		var job_button = Button.new()
		job_button.name = button_name
		job_button.text =  job.res_name
		job_button.toggle_mode = true
		job_button.button_group = button_group
		job_button.pressed.connect(_on_button_press.bind(job))
		work_buttons_container.add_child(job_button)
