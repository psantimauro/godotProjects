extends Node2D

@export var type:TileManager.tiles = TileManager.tiles.PICKUP

func pickup():
	Globals.item_picked_up.emit(type)
	self.queue_free()
