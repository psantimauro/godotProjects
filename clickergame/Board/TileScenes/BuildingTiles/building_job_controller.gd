class_name BuildingJobController
extends Node

func add_job(job: base_job_resource):
	remove_job()
	var new_job: GenerateMaterialJob = GenerateMaterialJob.new()
	new_job.job_resource = job
	new_job.job_resource.job_speed = 1
	
	add_child(new_job)
	
	new_job.start_job()


func remove_job():
	for node in get_children():
		node.queue_free()
