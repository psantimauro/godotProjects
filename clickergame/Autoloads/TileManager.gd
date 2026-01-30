extends Node
enum tiles {UNDEFINED = -1, SELECTION = 0, CAMPFIRE = 1, GRASS = 2, ROCK = 3, TREE = 4, TENT = 5, LOGCABIN = 6, WELL = 7, MUSHROOM = 8, TIPI = 9, DEER = 11, GENERIC_PICKUP = 12}
enum tile_types {GROUND, RESOURCE, BUILDING, PICKUP, ANIMALS}

func IsTypePickup(type) -> bool:
	match type:
		tiles.MUSHROOM:
			return true
		tiles.GENERIC_PICKUP:
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
	var building_name = Utilities.get_name_from_type(type, BuildingManager.building_types)

	return BuildingManager.is_building_unlocked(building_name)

func IsTypeTrader(type) -> bool:
	return type == tiles.TIPI

func IsTypeAnimal(type) -> bool:
	match type:
		tiles.DEER:
			return true
	return false
