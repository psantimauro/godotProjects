class_name BuildingBase
extends Node2D

@export var type:InventoryManager.building_types = InventoryManager.building_types.UNDEFINED


signal selected

@onready var research: Node = $Research
@onready var work: Node = $Work

var bar: TimerProgressBar
func click():
	selected.emit(self)


func _on_timer_timeout() -> void:
	pass # Replace with function body.

func _ready() -> void:
	child_entered_tree.connect(_new_kid)
	child_exiting_tree.connect(_bye_kid)
	
func _new_kid(node):
	print(node)
	bar = node.get_node("bar")
	bar.reparent(self)

func _bye_kid(kid):
	bar.reparent(kid)
	
	
	
