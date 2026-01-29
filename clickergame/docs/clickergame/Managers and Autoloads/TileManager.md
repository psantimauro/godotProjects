# Tile Manager

Autoload singleton (`TileManager.gd`)

Handles tile classification and type checking for the game board.

## Tile Categories
- **Ground**: Basic terrain.
- **Resource**: Interactable items like [[Trees]] and [[Rocks]].
- **Building**: Constructed structures like [[Tent]] or [[LogCabin]].
- **Pickup**: Seasonal or random items like [[Mushroom]].
- **Animals**: Mobile resources like [[Deer]].

## Core Functions
- `IsTypeResource(type)`: Returns true if the tile is a [[Resources|Resource]] (Tree, Rock).
- `IsTypeBuilding(type)`: Checks with [[BuildingManager]] if the tile is an unlocked building.
- `IsTypePickup(type)`: Returns true for items like Mushrooms.
- `IsTypeAnimal(type)`: Returns true for [[Animals]].
- `IsTypeTrader(type)`: Specifically checks for the [[Tipi]].
