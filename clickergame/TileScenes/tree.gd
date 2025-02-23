extends Node2D
@export var type = 4 #this maps backed to games tile types enum
@export var health = 10
@export var yield_amount = 1

signal destroyed 
var clicker = 0
func click():
	health -= 1
	if health < 1:
		destroyed.emit(yield_amount)
	$Label.text = str(health)
