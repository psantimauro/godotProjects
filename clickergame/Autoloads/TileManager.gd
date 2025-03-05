extends  Node
enum tiles  {UNDEFINED = -1, GRASS = 2, ROCK =3, TREE =4, PICKUP =10, TENT = 5, LOGCABIN = 6}

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
	match type:
		tiles.TENT:
			return true
		tiles.LOGCABIN:
			return true
	return false
