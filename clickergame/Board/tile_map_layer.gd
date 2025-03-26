extends TileMapLayer
class_name SceneTileMapLayer

var scene_coords = {}
func _enter_tree():
	child_exiting_tree.connect(_unregister_child)
	child_entered_tree.connect(_register_child)

func connect_signals(child):
	match child.get_signal_list()[0]["name"]:
		"selected":
			child.selected.connect(($"../..").selected) #game
		"clicked":
			child.selected.connect(($"..").on_clicked) #board
		"phase_complete":
			child.selected.connect(($"..").on_complete) #board
	
func _register_child(child):
	await child.ready
	connect_signals(child)
	var coords = local_to_map(to_local(child.global_position))
	var group_name = Globals.get_name_from_type(child.group_type, TileManager.tile_types)
	var type_name = Globals.get_name_from_type(child.type, TileManager.tiles)
	child.set_meta("type", child.type)
	child.add_to_group(group_name)
	child.set_meta("tile_coords", coords)
	child.name = type_name + "@" + str(coords)
	scene_coords[coords] = child
	

func _unregister_child(child):
	scene_coords.erase(child.name)
	var kids= []
	for kid in get_children():
		if child.name.begins_with(kid.name):
			kids.append(kid)
	if kids.size() > 1:
		scene_coords[child.name] = kids[1]

func get_cell_scene(coords: Vector2i) -> Node:
	if scene_coords.has(coords) and  scene_coords[coords] != null:
		return scene_coords[coords]
	return null

func has_child_at(coords):
	return scene_coords.h
