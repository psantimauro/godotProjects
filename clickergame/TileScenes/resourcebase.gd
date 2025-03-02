extends Node2D

#default behaor is grass
@export var type:TileManager.tiles = TileManager.tiles.UNDEFINED

@export var health = 1.0
@export var yield_amount = 0
@export var time = 1.0
@export var required_tool_type:InventoryManager.tool_types = InventoryManager.tool_types.UNDEFINED #todo
@export var yield_type: InventoryManager.material_types = InventoryManager.material_types.UNDEFINED 
signal destroyed 
signal phase_complete
signal clicked

var max_health

func _ready():
	max_health = health

@onready var progbar = $ProgressBar
func click():
	if InventoryManager.has_tool(required_tool_type):
		InventoryManager.use_tool(required_tool_type)
	#	var power = InventoryManager.get_tool_stregth(required_tool_type)
		$HealthBar.visible = true
		clicked.emit()
	#	progbar.power = power
		progbar.timer_duration = time
		progbar.show_percentage = true
		progbar.start()
		#health_bar.max_value = max_health
func _process(_delta: float) -> void:
	progbar.value += $ProgressBar.value

func _on_progress_bar_done() -> void:
	phase_complete.emit()
	progbar.show_percentage = false
	
	var power = InventoryManager.get_tool_stregth(required_tool_type)
	health -= (1 * power)
	$Label.text = str(health)
	var bar =  self.find_child("HealthBar")
	var new_val =  ((max_health-health)/max_health) * 100
	bar.value = new_val

	if health < 1:
		destroyed.emit(yield_amount)
