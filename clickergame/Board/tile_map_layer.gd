extends TileMapLayer
class_name SceneTileMapLayer

var scene_coords = {}
func _enter_tree():
	child_exiting_tree.connect(_unregister_child)
	child_entered_tree.connect(_register_child)


func _register_child(child):
	await child.ready
	var coords = local_to_map(to_local(child.global_position))
	var group_name = Utilities.get_name_from_type(child.group_type, TileManager.tile_types)
	var type_name = Utilities.get_name_from_type(child.type, TileManager.tiles)
	child.set_meta("type", child.type)
	child.add_to_group(group_name)
	child.set_meta("tile_coords", coords)
	child.name = type_name + "@" + str(coords)
	scene_coords[coords] = child
	

func _unregister_child(child):
	var coords = child.get_meta("tile_coords")
	if coords != null:
		scene_coords.erase(coords)

func get_cell_scene(coords: Vector2i) -> Node:
	if scene_coords.has(coords) and scene_coords[coords] != null:
		return scene_coords[coords]
	return null

func has_child_at(coords):
	return scene_coords.has(coords)
