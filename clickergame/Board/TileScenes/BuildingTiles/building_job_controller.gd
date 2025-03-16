class_name BuildingJobController
extends Node

func add_job(job: base_job_resource, timer):
	var new_job = null
	match job.type:
		BuildingManager.job_types.CREATE:
			new_job = GenerateMaterialJob.new()
			new_job.job_resource = job
			new_job.timer = timer
	if new_job != null:
		add_child(new_job)	
		new_job.start_job()


func remove_jobs():
	for node in get_children():
		node.queue_free()
