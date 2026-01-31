class_name Animal
extends Node2D

@export var group_type: TileManager.tile_types = TileManager.tile_types.ANIMALS
@export var type: TileManager.tiles

@export var yield_materials: Array[material_stack] = []
@export var max_health = 3
@export var time = 1.0
@export var strength_modifier = 0.001

@onready var health_bar: ProgressBar = $HealthBar
@onready var missed: Label = $Missed
@onready var mover = $Movable

var health: float:
	set(h):
		health = h
		var new = min(health / max_health * 100, 100)
		new = max(0, new)
		health_bar.value = new

var last_move_time: float = 0.0
var move_cooldown: float = 0.0

func _ready():
	health = max_health
	add_to_group(Utilities.get_name_from_type(TileManager.tile_types.ANIMALS, TileManager.tile_types))
	GameEvents.update_game_piece.connect(_on_update)
	# Each animal gets a random initial cooldown so they don't all move at once
	move_cooldown = randf_range(3.0, 8.0)
	last_move_time = Time.get_ticks_msec() / 1000.0

func click():
	var dice = randi_range(1, 6)

	var tool = ToolManager.get_hunting_tool()
	if tool != null && dice >= 5:
		health -= tool.strength
		health_bar.show()
		if health < 1:
			tool.strength += strength_modifier
			for stack: material_stack in yield_materials:
				InventoryManager.add_material_stack(stack)
			self.queue_free()
	else:
		missed.visible = true
		var tween = get_tree().create_tween()
		
		tween.tween_property(missed, "scale", Vector2.ONE, 1)
		tween.tween_property(missed, "modulate", Color.RED, 1)
		tween.tween_property(missed, "scale", Vector2(), 1)
		tween.tween_property(missed, "modulate", Color.WHITE, 1)
		tween.tween_property(missed, "scale", Vector2.ONE, 1)
		await get_tree().create_timer(0.75).timeout
		missed.visible = false

func try_move(try_move_pos: Vector2i) -> bool:
	return mover.move(try_move_pos)

func _on_update():
	print("animal " + str(self.name) + "ready to update")
	var name_parts = self.name.split("_")
	var location = Utilities.pos_string_to_vector2(name_parts[1])
	var rand_adj_vectors = Utilities.adjecent_vectors(location)
	rand_adj_vectors.shuffle()
	for try_move_pos in rand_adj_vectors:
			if try_move(try_move_pos):
				return
	return
