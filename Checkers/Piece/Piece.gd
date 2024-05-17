class_name Piece
extends Node2D

@export var color:String 
@export var kinged:bool = false: set =king


func _ready():
	if color == "red":
		$Sprite2D.setRed()
	else:
		$Sprite2D.setBlack()

func king(value):
	kinged = value
	if kinged:
		$Sprite2D.setKinged()
		
