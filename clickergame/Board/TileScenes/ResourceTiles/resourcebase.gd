extends Node2D

@export_category("Tile Type")
@export var group_type: TileManager.tile_types = TileManager.tile_types.GROUND
@export var type:TileManager.tiles = TileManager.tiles.GRASS
@export_category("Settings")
@export var health = 1.0
@export var yield_amount = 0
@export var time = 1.0
@export var required_tool_type: ToolManager.tool_types = ToolManager.tool_types.UNDEFINED
@export var yield_type: InventoryManager.material_types = InventoryManager.material_types.UNDEFINED 
signal destroyed 
signal phase_complete
signal clicked

var _max_health

func _ready():
	_max_health = health

@onready var progbar = $ProgressBar
func click():
	if ToolManager.has_tool(required_tool_type) and progbar.is_stopped():
		ToolManager.use_tool(required_tool_type)
		$HealthBar.visible = true
		clicked.emit()
		var tool_res = ToolManager.get_resource_from_tool_type(required_tool_type)
		progbar.texture = tool_res.texture
		progbar.audio_stream = tool_res.tool_sound
		progbar.timer_duration = time
		progbar.start()
		
func _process(_delta: float) -> void:
	progbar.value += $ProgressBar.value

func _on_progress_bar_done() -> void:
	phase_complete.emit()
	progbar.show_percentage = false
	
	var power = ToolManager.get_tool_stregth(required_tool_type)
	health -= (1 * power)
	$Label.text = str(health)
	var bar =  self.find_child("HealthBar")
	var new_val =  ((_max_health-health)/_max_health) * 100
	bar.value = new_val

	if health < 1:
		InventoryManager.add_material(yield_type,yield_amount)
		self.queue_free()
		#destroyed.emit(yield_amount)
