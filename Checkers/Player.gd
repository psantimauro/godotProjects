extends Node

@export var color = "": set =  setColor
func setColor(value):	
	value = value.to_lower()
	if value != "red" or value != "black":
		color = ""
	color = value
		

@export var totalPieces = 12
