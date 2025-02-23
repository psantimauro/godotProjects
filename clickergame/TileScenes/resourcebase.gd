extends Node2D

#default behaor is grass
@export var type:TileManager.tiles = TileManager.tiles.UNDEFINED

@export var health = 1
@export var yield_amount = 0
@export var time = 2
@export var required_tool_type:InventoryManager.tool_types = InventoryManager.tool_types.UNDEFINED #todo
@export var yield_type: InventoryManager.material_types = InventoryManager.material_types.UNDEFINED 
signal destroyed 
var clicker = 0

@onready var bar = $ProgressBar
func click():
	if InventoryManager.has_tool(required_tool_type):
		bar.speed = time
		#bar.speed = tool.factor * time
		bar.show_percentage = true
		bar.start()


func _on_progress_bar_done() -> void:
	bar.show_percentage = false
	health -= 1
	$Label.text = str(health)
	if health < 1:
		destroyed.emit(yield_amount)
