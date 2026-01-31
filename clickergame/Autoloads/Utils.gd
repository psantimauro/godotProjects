extends Node

func update_meta_location(item, coords):
	item.set_meta("type", item.type)
	
	var type_name = get_name_from_type(item.type, TileManager.tiles)
	
	item.set_meta("tile_coords", coords)
	item.name = type_name + "_" + str(coords)
	
func resize_texture(new_size: int, texture) -> ImageTexture:
	var image: Image = texture.get_image()
	image.resize(new_size, new_size)
	texture = ImageTexture.create_from_image(image)
	return texture

func haz(dict, type) -> bool:
	return dict.has(type)

func get_type_from_name(item_name: String, type):
	for key in type.keys():
		if item_name.to_lower() == (str(key).to_lower()):
			return type[key]
	return -1

func get_name_from_type(type, type_type) -> String:
	for key in type_type.keys():
		var val = type_type[key]
		if val == type:
			return str(key).to_lower()
	return ""

## Converts a string like "(1, 0)" into a Vector2
func pos_string_to_vector2(str_val: String):
	var parts = str_val.split(",")
	if parts.size() > 1:
		var x_part = parts[0].trim_prefix("(").trim_suffix(" ")
		var y_part = parts[1].trim_prefix(" ").trim_suffix(")")
		return Vector2(str_to_var(x_part), str_to_var(y_part))
	return Vector2.INF

func pos_from_name(item_name) -> Vector2i:
	var name_parts = item_name.split("_")
	if name_parts.size() > 1:
		return Utilities.pos_string_to_vector2(name_parts[1])
	return Vector2i.MAX
func adjecent_vectors(offset:Vector2i = Vector2i.ZERO) -> Array[Vector2i]:
	var adj_vectors: Array[Vector2i] = []
	adj_vectors.append(offset + Vector2i(-1, -1))
	adj_vectors.append(offset + Vector2i(-1, 0))
	adj_vectors.append(offset + Vector2i(-1, 1))
	adj_vectors.append(offset + Vector2i(0, -1))
	adj_vectors.append(offset + Vector2i(0, 1))
	adj_vectors.append(offset + Vector2i(1, -1))
	adj_vectors.append(offset + Vector2i(1, 0))
	adj_vectors.append(offset + Vector2i(1, 1))
	return adj_vectors
