extends Node

signal item_picked_up

signal empty_tile_selected

signal resource_clicked

signal clear_selection
signal delete_selected_building

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
