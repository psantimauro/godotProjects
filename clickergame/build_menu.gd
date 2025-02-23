extends VFlowContainer

signal  build_button_clicked

func _ready() -> void:
	InventoryManager.building_built.connect(_on_building_built)

func _on_building_built(_build_type):
	toggleBuildMenu()

func toggleBuildMenu(visible = null):
	if visible != null:
		$Button.visible = visible
	else:
		$Button.visible = !$Button.visible


func _on_button_pressed() -> void:
	build_button_clicked.emit(InventoryManager.build_types.TENT) #0 is the type for tent
