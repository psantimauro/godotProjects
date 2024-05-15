class_name Piece
extends Node2D

@export var color:String 
@export var kinged:bool = false

func _ready():
	if color == "red":
		$Sprite2D.setRed()
	else:
		$Sprite2D.setBlack()

func king():
	kinged = true
	$Sprite2D.setKing()
		
