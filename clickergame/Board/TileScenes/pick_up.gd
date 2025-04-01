extends Node2D

@export var icon: Texture:
	set(text):
		for child in self.get_children():
			if child is Sprite2D:
				child.texture = text
		icon = text
@export var sound: AudioStream:
	set(stream):
		audio_stream_player_2d.stream = stream
		sound = stream
		
@export var group_type: TileManager.tile_types = TileManager.tile_types.PICKUP
@export var type:TileManager.tiles = TileManager.tiles.GENERIC_PICKUP
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func pickup():
	audio_stream_player_2d.play()
	Globals.item_picked_up.emit(self)
	self.visible = false
	await get_tree().create_timer(0.5).timeout #give audio time to play
	self.queue_free()
