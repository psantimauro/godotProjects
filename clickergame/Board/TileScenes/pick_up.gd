extends Node2D


@export var group_type: TileManager.tile_types = TileManager.tile_types.PICKUP
@export var type:TileManager.tiles = TileManager.tiles.PICKUP
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func pickup():
	audio_stream_player_2d.play()
	Globals.item_picked_up.emit(type)
	self.visible = false
	await get_tree().create_timer(0.5).timeout
	self.queue_free()
