extends Camera2D

@export var camera_speed = 5
@export var zoom_factor = Vector2(0.05, 0.05)
@export var board_size = Vector2.ZERO
@export var max_zoom = Vector2.ONE
@export var min_zoom = Vector2(0.5,0.5)
var dragging = false
var org_pos = Vector2.ZERO
var move_pos = Vector2.ZERO#:
	#set(pos):
	#	if abs(pos.x) > board_size.x:
	#		pos.x = pos.x
	#	if abs(pos.y) > board_size.y:
	#		pos.y = pos.y
	#	move_pos = pos


func move_to(pos: Vector2):
	move_pos = pos #+ cam_delta
var fast_scroll = false
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("move_fast"):
		fast_scroll = true
	else:
		fast_scroll = false
	
	if Input.is_action_just_pressed("zoom_in"):
		zoom += zoom_factor
#		print("Zoom at " + str(zoom))
	elif Input.is_action_just_pressed("zoom_out"):
		zoom -= zoom_factor 
#		print("Zoom at " + str(zoom))
		
	if zoom > max_zoom:
		zoom = max_zoom
	elif zoom < min_zoom:
		zoom = min_zoom

func _physics_process(delta: float) -> void:
	var pos_delta =  move_pos - self.get_screen_center_position()
	var move_velocity = get_velocity()

	if move_velocity != Vector2.ZERO:
		move_pos = position
		position += move_velocity	
#		print("Camera to " + str(position))
	elif abs(pos_delta) > Vector2.ONE * 10:
#		print("Camera deltaing by " + str(pos_delta))
		var movement =  pos_delta * delta * camera_speed
		#move_pos = move_pos - movement
		position += movement
#		print("Camera to " + str(position))


func get_velocity():
	var input_direction = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	var velocity = input_direction * camera_speed
	if fast_scroll:
		velocity *= 4
	return velocity
