class_name  building_resource
extends base_resource

@export var requirements: Array[material_stack]
@export var res_type: BuildingManager.building_types = BuildingManager.building_types.UNDEFINED

@export var unlockable_jobs : Array[base_job_resource] = []
@export var unlocked_jobs : Array[base_job_resource] = []

@export var unlockable_tech : Array[base_tech_resource] = []
@export var unlocked_tech : Array[base_tech_resource] = []
