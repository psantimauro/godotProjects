extends  Node
enum tiles  {UNDEFINED = -1, SELECTION = 0, CAMPFIRE = 1, GRASS = 2, ROCK =3, TREE =4,  TENT = 5, LOGCABIN = 6, PICKUP =8, DEER = 11}
enum tile_types {GROUND, RESOURCE, BUILDING, PICKUP, ANIMALS} 

func IsTypePickup(type)-> bool:
	match type:
		tiles.PICKUP:
			return true
	return false
func IsTypeResource(type) -> bool:
	match type:
		tiles.ROCK:
			return true
		tiles.TREE:
			return true
	return false

func IsTypeBuilding(type) -> bool:
	var rtn =  BuildingManager.is_building_unlocked(Globals.get_name_from_type(type,BuildingManager.building_types))
	return rtn

func IsTypeAnimal(type) ->bool:
	match type:
		tiles.DEER:
			return true
	return false
	
