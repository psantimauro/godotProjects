extends Node
@warning_ignore_start("unused_signal") #these are all used, just not here 
# --- Inventory Events ---
signal material_amount_updated(type: InventoryManager.material_types, amount: int)
signal new_material_unlocked(resource: material_resource)

# --- Building Events ---
signal building_built(type: BuildingManager.building_types)
signal building_unlocked(type: BuildingManager.building_types)
signal building_selected(building: BuildingBase)
signal job_unlocked(job: base_job_resource, building_type: BuildingManager.building_types)
signal tech_unlocked(tech: base_tech_resource, building_type: BuildingManager.building_types)

# --- Quest Events ---
signal quest_status_changed(quest: QuestResource, status: int, description: String, quest_type: String)

# --- Tool Events ---
signal tool_unlocked(resource: tool_resource)
signal tool_strength_changed(type: ToolManager.tool_types, strength: float)

# --- Board & Selection Events ---
signal item_picked_up(item: Node)
signal empty_tile_selected(pos: Vector2)
signal resource_clicked
signal resource_harvest_phase_complete
signal clear_selection
signal delete_selected_building
signal update_game_piece

# --- UI & Message Events ---
signal display_message_with_title(message: String, title: String)
signal display_item(item: Node)
@warning_ignore_restore("unused_signal")
