class_name BuildingWork
extends Control

@onready var work_buttons_container: VBoxContainer = $WorkContainer

@onready var building: BuildingBase =  $"../.."

@export var button_texture: Texture
var button_group: ButtonGroup = ButtonGroup.new()
func _on_button_press(job):
	building.start_job(job)
	Globals.clear_selection.emit()


func add_job(job):
	add_job_button(job)

func add_job_button(job:base_job_resource):
	var mat_name:String =  InventoryManager.material_types.keys()[job.job_result.material_type]
	var button_name = str(mat_name + "Button")
	var job_button = Button.new()
	job_button.name = button_name
	job_button.text =  job.res_name + " Lvl " + str(job.job_level) #this is incorrect as we only add the buttons once
	job_button.toggle_mode = true
	job_button.button_group = button_group
	job_button.pressed.connect(_on_button_press.bind(job))
	work_buttons_container.add_child(job_button)

func clear():
	for item in work_buttons_container.get_children():
		item.queue_free()
