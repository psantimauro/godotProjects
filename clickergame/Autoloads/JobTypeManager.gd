extends Node
#todo fix this is a resource and not a type
var unlocked_job_types: Array[base_job_resource]= []

func unlock_job(job: base_job_resource):
	if job != null:
		unlocked_job_types.append(job)

func get_unlocked_jobs_for_building(type: InventoryManager.building_types) -> Array[base_job_resource]:
	var return_jobs: Array[base_job_resource] = []
	for job in unlocked_job_types:
		if job.required_building == type:
			return_jobs.append(job)
	return return_jobs
	
	
const TENT_HIDE_CREATE_JOB = preload("res://Resources/job_resources/create_jobs/Tent_Hide_Create_Job.tres")
const TENT_MEAT_CREATE_JOB = preload("res://Resources/job_resources/create_jobs/Tent_Meat_Create_Job.tres")
const TENT_STONE_CREATE_JOB = preload("res://Resources/job_resources/create_jobs/Tent_Stone_Create_Job.tres")
const TENT_WOOD_CREATE_JOB = preload("res://Resources/job_resources/create_jobs/Tent_Wood_Create_Job.tres")
