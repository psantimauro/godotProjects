extends Node2D

@export_category("Tile Type")
@export var type:TileManager.tiles = TileManager.tiles.UNDEFINED

@export_category("Settings")
@export var health = 1.0
@export var yield_amount = 0
@export var time = 1.0
@export var required_tool_type:InventoryManager.tool_types = InventoryManager.tool_types.UNDEFINED #todo
@export var yield_type: InventoryManager.material_types = InventoryManager.material_types.UNDEFINED 
signal destroyed 
signal phase_complete
signal clicked

var _max_health

func _ready():
	_max_health = health

@onready var progbar = $ProgressBar
func click():
	if InventoryManager.has_tool(required_tool_type):
		InventoryManager.use_tool(required_tool_type)
		$HealthBar.visible = true
		clicked.emit()

		progbar.timer_duration = time
		progbar.show_percentage = true
		progbar.start()
		
func _process(_delta: float) -> void:
	progbar.value += $ProgressBar.value

func _on_progress_bar_done() -> void:
	phase_complete.emit()
	progbar.show_percentage = false
	
	var power = InventoryManager.get_tool_stregth(required_tool_type)
	health -= (1 * power)
	$Label.text = str(health)
	var bar =  self.find_child("HealthBar")
	var new_val =  ((_max_health-health)/_max_health) * 100
	bar.value = new_val

	if health < 1:
		destroyed.emit(yield_amount)
