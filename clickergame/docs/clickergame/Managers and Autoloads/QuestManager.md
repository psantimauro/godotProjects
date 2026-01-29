# Quest Manager

Autoload singleton (`QuestManager.gd`)

Orchestrates the [[Quests]] system, integrating with the **Questify** addon to manage progression, requirements, and rewards.

## Quest Systems
1. **Main Quests**: Handled via `firstquest_res_array`. These guide the player through core progression.
2. **Collect Quests**: Automatically generated when new materials are unlocked. These scale in difficulty and reward (e.g., unlocking new jobs or research).

## Rewarding Logic
Supports various reward types via `reward_types` enum:
- `RESEARCH`: Unlocks new [[Research]] in a building.
- `NEW_BUILDING`: Makes a new [[Buildings|building type]] available.
- `MATERIAL`: Grants a flat amount of a material ([[Resources]]).
- `JOB`: Unlocks a new [[Jobs|job]] in a building.
- `TRADER`: Unlocks the trading mechanic globally.

## Integration
- Listens for `new_material_unlocked` from `InventoryManager` to trigger dynamic collection quests.
- Provides condition queries to Questify for:
    - `has_material`
    - `has_building`
    - `has_tool`
    - `material_multi` (scaling requirements)
