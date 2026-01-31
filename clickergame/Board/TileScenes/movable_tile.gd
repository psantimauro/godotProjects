extends Node2D

@export var is_sprite_left_facing = true
func move(new_tile_pos: Vector2i, move_time = -1.0) -> bool:
	var item: Node2D = get_parent()
	var tile_map: SceneTileMapLayer = get_node_or_null("/root/Game/Board/GameLayer")
	var ground_layer: TileMapLayer = get_node_or_null("/root/Game/Board/GroundLayer")
	var sprite = item.get_node_or_null("Sprite2D")
	
	# Validate the move is legal
	if tile_map == null or ground_layer == null:
		return false
	if tile_map.has_child_at(new_tile_pos) or !ground_layer.has_child_at(new_tile_pos):
		return false
	
	# Get the old position from the item's current location
	var old_coords = tile_map.local_to_map(item.position)
	
	# Update the tilemap's tracking dictionary
	tile_map.move_tile(item, old_coords, new_tile_pos)
	

	if sprite:
		# Handle Sprite Flipping
		var new_local = tile_map.map_to_local(new_tile_pos)
		var start_local = tile_map.map_to_local(old_coords)

		if !is_equal_approx(new_local.x, start_local.x):
			if new_local.x > start_local.x:
				sprite.flip_h = is_sprite_left_facing
			else:
				sprite.flip_h = !is_sprite_left_facing
		# Animate the movement
		var duration = randf_range(0.2, 1.0)
		if move_time != -1:
			duration = move_time
		var t = create_tween()
		t.tween_property(item, "position", new_local, duration)
	
	return true
