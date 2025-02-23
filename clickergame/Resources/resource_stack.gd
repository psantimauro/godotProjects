class_name ResourceStack
extends Object

@export var amount: int

@export var res:resource_resource


func _init(resource, current_amount):
	res = resource
	amount = current_amount
	regen_rate = res.regen_rate

var max_amount: 
	get:
		return res.maxAmount

var res_name:
	get:
		return res.res_name 

var texture: 
	get:
		return res.texture

var regen_rate
