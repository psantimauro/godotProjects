class_name BuildingBase
extends Node2D
@export var type = 0 #this maps backed to games building types enum
signal selected

@onready var research: Node = $Research
@onready var work: Node = $Work

func click():
	selected.emit(self)
