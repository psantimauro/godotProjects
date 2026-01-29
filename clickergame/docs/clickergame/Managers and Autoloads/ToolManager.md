# Tool Manager

Autoload singleton (`ToolManager.gd`)

Manages the player's collection of [[Tools]] and their respective strengths/efficiency.

## Tool Types
- `AXE` (Lumberjacking - see [[Trees]])
- `PICKAXE` (Mining - see [[Rocks]])
- [[Knife]] (Hunting)
- `HAMMER` (Building - see [[Buildings]])

## Mechanics
- **Tool Strength**: Tools have a `strength` value that increases slightly each time they are used (`use_tool`).
- **Best Tool Selection**: Automatically provides the most effective tool for a specific usage (e.g., `get_lumberjacking_tool`).
- **Unlocking**: Tools are unlocked via `unlock_tool(type)`, often triggered by item pickups in the game world.

## Signals
- `tool_unlocked`: Emitted when a new tool is added to the player's collection.
- `tool_strength_changed`: Emitted when a tool's efficiency increases.
