extends Node

signal building_built
signal building_unlocked
signal job_unlocked
signal tech_unlocked
enum building_types {UNDEFINED = -1, TENT = 5, LOGCABIN = 6}
enum job_types {UNDEFINED = -1, CREATE}
enum tech_types {UNDEFINED = -1, JOB_UNLOCK}

var TENT = load("res://Resources/building_resources/tent.tres")
var LOGCABIN = load("res://Resources/building_resources/logcabin.tres")
var RESEARCH_ICON = preload("res://3rd Party/assets/icons/flask_half.png")

var unlocked_jobs_by_building: Dictionary[building_types, Array] = {}
var unlocked_tech_by_building: Dictionary[building_types, Array] = {}
func get_resource_from_building_type(type:building_types) -> building_resource:
	match type:
		building_types.TENT:
			return TENT
		building_types.LOGCABIN:
			return LOGCABIN
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
	var res:building_resource = get_resource_from_building_type(build_type)
	var new_jobs = []
	var new_tech = []
	for j in res.unlocked_jobs:
		new_jobs.append(j)
	for t in res.unlocked_tech:
		new_tech.append(t)
	unlocked_jobs_by_building[build_type] = new_jobs
	unlocked_tech_by_building[build_type] = new_tech
	unlocked_buildings[build_type] = res
	building_unlocked.emit(build_type)
	
func get_unlocked_jobs_for_building(type: building_types) -> Array[base_job_resource]:
	return unlocked_jobs_by_building[type]

func unlock_job_by_tech(tech: job_unlock_tech, building):
	var job = tech.unlocked_job
	unlock_job_for_building(job, building)

func unlock_job_for_building(job: base_job_resource, building:building_types):
	var found = false
	for j:base_job_resource in unlocked_jobs_by_building[building]:
		if job.res_name == j.res_name:
			found = true
	if !found:
		unlocked_jobs_by_building[building].append(job)
		job_unlocked.emit(job, building)

func unlock_job_for_building_by_name(building: building_types, job_type_name:String):
	var building_res: building_resource = get_resource_from_building_type(building)
	for job in building_res.unlockable_jobs:
		if job.res_name == job_type_name:
			unlock_job_for_building(job, building)

func unlocked_tech_for_building(building: building_types, tech_name):
	var building_res: building_resource = get_resource_from_building_type(building)
	var i = 0
	var found_at = -1
	var item = null
	for tech in building_res.unlockable_tech:
		if tech.res_name == tech_name:
			building_res.unlocked_tech.append(tech)
			tech_unlocked.emit(tech, building)
			found_at = i
		i += 1
	if found_at > -1:
		building_res.unlockable_tech.remove_at(found_at)
		return true
	return false
	
func unlock_research(tech:base_tech_resource) -> bool:
	var res: building_resource = get_resource_from_building_type(tech.required_building)
	var i = 0
	var found_at = -1
	var item = null
	for u_t in res.unlockable_tech:
		if u_t.res_name == tech.res_name:
			res.unlocked_tech.append(tech)
			found_at = i
		i += 1
	if found_at > -1:
		res.unlockable_tech.remove_at(found_at)
		tech_unlocked.emit()
		return true
	return false

func get_unlocked_research_by_building_type(type: BuildingManager.building_types) ->  Array[base_tech_resource]:
	var res: building_resource = get_resource_from_building_type(type)
	return res.unlocked_tech
