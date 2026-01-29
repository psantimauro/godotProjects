# Jobs

Jobs are the primary way players automate resource production and progress through the game.

## Mechanics
- **Assigned to Buildings**: Jobs run within specific [[Buildings]] (e.g., [[LogCabin]]).
- **Efficiency**: Jobs have a `job_speed` and `job_level`. 
- **Leveling**: Using [[BuildingManager|BuildingManager.level_job_by_building_type]], jobs can be leveled up to improve their speed.
- **Requirements**: Jobs may require specific [[Tools]] or materials to run.
- **Output**: Most jobs produce [[Resources|Materials]] (defined in `material_create_job`).

## Types of Jobs
- **Collection**: Gathering materials from the environment (e.g., [[Lumberjacking]], [[Trapping]]).
- **Production**: Converting one resource into another.
- **Construction**: Assisting in build projects.
