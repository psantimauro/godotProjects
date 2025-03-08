extends Node

signal building_built
signal building_unlocked
enum building_types {UNDEFINED = -1, TENT = 5, LOGCABIN = 6}
enum job_types {UNDEFINED = -1, CREATE}
enum tech_types {UNDEFINED = -1, JOB_UNLOCK}
const TENT = preload("res://Resources/building_resources/tent.tres")
const LOGCABIN = preload("res://Resources/building_resources/logcabin.tres")

func get_resource_from_building_type(type:building_types) -> building_resource:
	match type:
		building_types.TENT:
			return TENT
		building_types.LOGCABIN:
			return LOGCABIN
	return  null
	
func build(build_type: building_types):
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

func unlock_building(build_type: building_types):
	building_unlocked.emit(build_type)
	
func get_unlocked_jobs_for_building(type: building_types) -> Array[base_job_resource]:
	var res = get_resource_from_building_type(type)
	return res.unlocked_jobs

func unlock_job(tech: job_unlock_tech) -> bool:
	var job = tech.unlocked_job
	var job_building_res: building_resource = get_resource_from_building_type(job.required_building)
	var i = 0
	var found_at = -1
	var item = null
	for unlockable_job in job_building_res.unlockable_jobs:
		if unlockable_job.res_name == job.res_name:
			job_building_res.unlocked_jobs.append(job)
			found_at = i
		i += 1
	if found_at > -1:
		job_building_res.unlockable_jobs.remove_at(i)
		return true
	return false

func unlock_job_for_building(building: building_types, job_type_name):
	var building_res: building_resource = get_resource_from_building_type(building)
	var i = 0
	var found_at = -1
	var item = null
	for job in building_res.unlockable_jobs:
		if job.res_name == job_type_name:
			building_res.unlocked_jobs.append(job)
			found_at = i
		i += 1
	if found_at > -1:
		building_res.unlockable_jobs.remove_at(found_at)
		return true
	return false
const RESEARCH_ICON = preload("res://3rd Party/assets/icons/flask_half.png")

func unlocked_tech_for_building(building: building_types, tech_name):
	var building_res: building_resource = get_resource_from_building_type(building)
	var i = 0
	var found_at = -1
	var item = null
	for tech in building_res.unlockable_tech:
		if tech.res_name == tech_name:
			building_res.unlocked_tech.append(tech)
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
		return true
	return false
		
func get_unlocked_research_by_building_type(type: BuildingManager.building_types) ->  Array[base_tech_resource]:
	var res: building_resource = get_resource_from_building_type(type)
	return res.unlocked_tech
