# Inventory Manager

Autoload singleton (`InventoryManager.gd`)

Maintains the player's stock of [[Resources]] (materials) and handles material unlocking.

## Material Types
Supported materials (defined in `material_types` enum):
- [[Wood]]
- [[Stone]]
- [[Buffalo Hides]]
- [[Meat]]
- [[Water]]
- [[Gold]]

## Signals
- `material_amount_updated(type, amount)`: Emitted when a material count changes.
- `new_material_unlocked(resource)`: Emitted when a material is first added to the inventory.

## Core Functions
- `add_material(type, amount)`: Adds a specified amount of a material. Unlocks the material if it's the first time receiving it.
- `remove_material(type, amount)`: Deducts a specified amount (e.g., for building costs).
- `has_material(name, amount)`: Checks if the inventory contains at least the specified amount of a material (supports "any" for flexible checks).
- `has_material_stack(stack)`: Checks if a `material_stack` requirement is met.