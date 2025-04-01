extends Node

signal item_picked_up
signal empty_tile_selected
signal resource_clicked

signal clear_selection
signal delete_selected_building

signal display_message_with_title
signal display_item

var traders_unlocked = false

func resize_texture(new_size: int, texture)-> ImageTexture:
	var image:Image = texture.get_image()
	image.resize(new_size,new_size)
	texture = ImageTexture.create_from_image(image)
	return texture

func haz(dict, type) -> bool:
	return dict.has(type)

func get_type_from_name(name: String, type) :
	for key in type.keys():
		if name.to_lower() == (str(key).to_lower()):
			return type[key]
	return -1

func get_name_from_type(type, type_type) -> String:
	for key in type_type.keys():
		var val = type_type[key]
		if val == type:
			return str(key).to_lower()
	return ""

## Converts a string like "(1, 0)" into a Vector2
func pos_string_to_vector2(str):
	var parts = str.split(",")
	var output = null
	if parts.size() > 1:
		var x_part = parts[0].trim_prefix("(").trim_suffix(" ")
		var y_part = parts[1].trim_prefix(" ").trim_suffix(")")
		return Vector2(str_to_var(x_part), str_to_var(y_part))
		
func adjecent_vectors() -> Array[Vector2]:
	var adj_vectors:Array[Vector2] = []
	adj_vectors.append(Vector2(-1,-1))
	adj_vectors.append(Vector2(-1,0))
	adj_vectors.append(Vector2(-1,1))
	adj_vectors.append(Vector2(0,-1))
	adj_vectors.append(Vector2(0,1))
	adj_vectors.append(Vector2(1,-1))
	adj_vectors.append(Vector2(1,0))
	adj_vectors.append(Vector2(1,1))
	return adj_vectors
		
