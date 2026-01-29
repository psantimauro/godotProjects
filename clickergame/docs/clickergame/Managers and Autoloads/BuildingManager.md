# Building Manager

Autoload singleton (`BuildingManager.gd`)

Handles [[Buildings]] unlocking, construction costs, and [[Jobs]]/[[Research]] management within buildings.

## Building Types
Defined in `building_types` enum:
- [[Campfire]]
- [[Tent]]
- [[LogCabin]]
- [[Well]]
- [[Tipi]]

## Signals
- `building_built`: Emitted when a construction project is successfully started.
- `building_unlocked`: Emitted when a new building type becomes available for construction.
- `job_unlocked`: Emitted when a new job becomes available in a building.
- `tech_unlocked`: Emitted when a new research item becomes available.

## Construction logic
- Construction depends on `building_resource` requirements (`material_stack` array).
- `build(type)` checks `InventoryManager` for required materials before emitting `building_built`.

## Job & Tech Management
- Buildings have both **unlocked** and **unlockable** jobs/tech.
- Provides functions to level up jobs (`level_job_by_building_type`) and unlock specific creation jobs by material name.
