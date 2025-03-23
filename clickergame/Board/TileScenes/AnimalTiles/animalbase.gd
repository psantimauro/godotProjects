extends Node

@export var group_type:TileManager.tile_types = TileManager.tile_types.ANIMALS
@export var type:TileManager.tiles

@export var yield_materials: Array[material_stack] = []
@export var max_health = 10
@export var time = 1.0
@onready var health_bar: ProgressBar = $HealthBar
@onready var missed: Label = $Missed


var health: float:
	set(h):
		health = h
		var new = min( health/max_health * 100 , 100)
		new = max(0, new)
		health_bar.value = new

func _ready():
	health = max_health
	add_to_group(Globals.get_name_from_type(TileManager.tile_types.ANIMALS, TileManager.tile_types))

		
func click():
	health_bar.show()
	var dice = randi_range(1,6)
	var hit = false
	if dice >=5:
		health -= 1
		if health < 1:
			for stack:material_stack in yield_materials:
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
	
