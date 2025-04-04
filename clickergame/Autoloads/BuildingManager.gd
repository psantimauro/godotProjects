extends Node

signal building_built
signal building_unlocked
signal job_unlocked
signal tech_unlocked

enum building_types {UNDEFINED = -1, CAMPFIRE = 1, TENT = 5, LOGCABIN = 6, WELL = 7, TIPI=9}
enum job_types {UNDEFINED = -1, CREATE}
enum tech_types {UNDEFINED = -1, JOB_UNLOCK, IMPROVE_CREATE_JOB}

var TENT = load("res://Resources/building_resources/tent.tres")
var LOGCABIN = load("res://Resources/building_resources/logcabin.tres")
var RESEARCH_ICON = preload("res://3rd Party/assets/icons/flask_half.png")
const CAMPFIRE = preload("res://Resources/building_resources/campfire.tres")
const WELL = preload("res://Resources/building_resources/well.tres")
const TIPI = preload("res://Resources/building_resources/tipi.tres")

var unlocked_jobs_by_building: Dictionary[building_types, Array] = {}
var unlocked_tech_by_building: Dictionary[building_types, Array] = {}
func get_resource_from_building_type(type:building_types) -> building_resource:
	match type:
		building_types.TENT:
			return TENT
		building_types.LOGCABIN:
			return LOGCABIN
		building_types.CAMPFIRE:
			return CAMPFIRE
		building_types.WELL:
			return WELL
		building_types.TIPI:
			return TIPI
	return  null
	
func build(build_type: building_types):
	if build_type == building_types.UNDEFINED:
		return
	var building_res = get_resource_from_building_type(build_type)
	if has_all_resources_to_build(building_res):
		print("building: " + str(build_type))
		for requirement:material_stack in building_res.requirements:
			InventoryManager.remove_material(requirement.material_type, requirement.material_amount)
		building_built.emit(build_type)
	else:
		print("dont have build stuffs")
func has_all_resources_to_build(building_res: building_resource) -> bool:
	var has_all = true
	for requirement:material_stack in building_res.requirements:
		if !InventoryManager.has_material_stack(requirement):
			has_all = false
	return has_all
func is_building_unlocked(res_name: String) ->bool:
	for key in building_types.keys():
		var name  = key.to_lower()
		if  name == res_name:
			var building_key = building_types[key]
			if unlocked_buildings.has(building_key):
				return true
	return false
var unlocked_buildings: Dictionary[building_types,building_resource]
func unlock_building(build_type: building_types):
	
	building_unlocked.emit(build_type) #emit the building first so other things are ready for it
	
	var res:building_resource = get_resource_from_building_type(build_type)
	var new_jobs = []
	var new_tech = []
	for j in res.unlocked_jobs:
		new_jobs.append(j)
		job_unlocked.emit(j, build_type)
	for t in res.unlocked_tech:
		new_tech.append(t)
		tech_unlocked.emit(t, build_type)
	unlocked_jobs_by_building[build_type] = new_jobs
	unlocked_tech_by_building[build_type] = new_tech
	unlocked_buildings[build_type] = res
	
	for item in unlocked_jobs_by_building[build_type]:
		unlock_job_for_building(item,build_type)
func unlock_job_for_building(job: base_job_resource, building:building_types, include_new_improvement_research = false):
	var found = false
	for j:base_job_resource in unlocked_jobs_by_building[building]:
		if job.res_name == j.res_name:
			found = true
	if !found:
		unlocked_jobs_by_building[building].append(job)
		job_unlocked.emit(job, building)
	if include_new_improvement_research && (job is material_create_job):
		var improvement_tech = job_improve_tech.new()
		improvement_tech.repeatable = true
		improvement_tech.improve_job = job
		improvement_tech.tech_type = tech_types.IMPROVE_CREATE_JOB
		improvement_tech.resource_name = "Improve " + job.res_name + ".  This technology is repeatable."
		unlocked_tech_for_building_no_check(building, improvement_tech)

func unlock_job_by_tech(tech, building):
	var job = tech.unlocked_job
	unlock_job_for_building(job, building)
func get_job_from_material(material_name: String) -> String:
	var job_type_name  = ""
	match material_name:
		"wood":
			job_type_name = "Lumberjack"
		"hide":
			job_type_name = "Trapping"
		"meat":
			job_type_name = "Hunt and Gather"
		"stone":
			job_type_name = "Mine Stone"
		_:
			print("no match found!!!")
	return job_type_name
func unlock_mat_create_job_for_building_by_mat_name(building: building_types, material_name:String):

			
	var building_res: building_resource = get_resource_from_building_type(building)
	for job in building_res.unlockable_jobs:
		var converted = get_job_from_material(material_name)
		var job_name = job.res_name
		if job_name == converted:
			unlock_job_for_building(job, building)

func unlocked_improve_job_tech_for_building_by_material_name(building: building_types, incoming_material_name:String):
	var building_res: building_resource = get_resource_from_building_type(building)
	for job in building_res.unlockable_jobs:
		var job_material_name = Globals.get_name_from_type(job.job_result[0].material_type, InventoryManager.material_types)
		if  job_material_name == incoming_material_name:
			var improvement_tech = job_improve_tech.new()
			improvement_tech.repeatable = true
			improvement_tech.improve_job = job
			improvement_tech.tech_type = tech_types.IMPROVE_CREATE_JOB
			improvement_tech.resource_name = "Improve " + job.res_name + ".  This technology is repeatable."
			unlocked_tech_for_building_no_check(building, improvement_tech)

func unlocked_tech_for_building_no_check(building, tech):
	var building_res: building_resource = get_resource_from_building_type(building)
	tech_unlocked.emit(tech, building)
	unlocked_tech_by_building[building].append(tech)
	
func unlocked_tech_for_building(building: building_types, tech_name):
	var building_res: building_resource = get_resource_from_building_type(building)
	var i = 0
	var found_at = -1
	var item = null
		
	for tech in building_res.unlockable_tech:
		if tech.res_name == tech_name:
			#building_res.unlocked_tech.append(tech)
			unlocked_tech_by_building[building].append(tech)
			tech_unlocked.emit(tech, building)
			found_at = i
		i += 1
	if found_at > -1:
		#building_res.unlockable_tech.remove_at(found_at)
		return true
	return false
	
func get_unlocked_research_by_building_type(type: BuildingManager.building_types) ->  Array[base_tech_resource]:
	var res: building_resource = get_resource_from_building_type(type)
	return res.unlocked_tech

@export var level_factor =0.05
func level_job_by_building_type(building_type, job_to_level):
	for job in unlocked_jobs_by_building[building_type]:
		if job == job_to_level:
			job.job_level += 1
			job.job_speed -= level_factor*job.job_level
