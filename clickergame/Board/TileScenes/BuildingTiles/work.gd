extends Control
@onready var button: Button = $VBoxContainer/Button
@onready var button_2: Button = $VBoxContainer/Button2
@onready var button_3: Button = $VBoxContainer/Button3

@onready var jobs_container: BuildingJobController = $JobsContainer

func _ready() -> void:
	await button
	button.pressed.connect(_on_button_press)
	button_2.pressed.connect(_but2)
	button_3.pressed.connect(_but3)
	
func _but2():
	_on_button_press(InventoryManager.material_types.HIDE)
func _but3():
	_on_button_press(InventoryManager.material_types.MEAT)
		
func _on_button_press(type = InventoryManager.material_types.WOOD, amount = 1):
	var job = material_create_job.new()
	job.job_result = material_stack.new()
	job.job_result.material_type = type
	job.job_result.material_amount = amount
	
	jobs_container.add_job(job)
	
