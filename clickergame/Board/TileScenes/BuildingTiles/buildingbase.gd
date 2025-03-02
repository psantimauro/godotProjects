class_name BuildingBase
extends Node2D

@export var type:InventoryManager.building_types = InventoryManager.building_types.UNDEFINED

signal selected

@onready var research: Node = $Research
@onready var work: Node = $Work

func click():
	selected.emit(self)


func _on_timer_timeout() -> void:
	pass # Replace with function body.
