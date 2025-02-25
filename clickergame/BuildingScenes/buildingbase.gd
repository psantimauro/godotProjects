extends Node2D
@export var type = 0 #this maps backed to games building types enum
signal selected

func click():
	selected.emit()
