extends Camera2D

@export var camera_speed = 5
@export var zoom_factor = Vector2(0.05, 0.05)
@export var board_size = Vector2.ZERO
var dragging = false
var org_pos = Vector2.ZERO
var move_pos = Vector2.ZERO:
	set(pos):
		if abs(pos.x) > board_size.x:
			pos.x = pos.x
		if abs(pos.y) > board_size.y:
			pos.y = pos.y
		move_pos = pos


func move_to(pos: Vector2):
	move_pos = pos

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("camera_drag"):
		camera_speed = 20
		org_pos = get_global_mouse_position()
		dragging = true
	elif  Input.is_action_just_released("camera_drag"):
		camera_speed = 5
		dragging = false
	
	if Input.is_action_just_pressed("zoom_in"):
		zoom += zoom_factor
		print(zoom)
	elif Input.is_action_just_pressed("zoom_out"):
		zoom -= zoom_factor 
	if zoom == Vector2.ZERO:
		zoom = zoom_factor
	if zoom > Vector2.ONE:
		zoom = Vector2.ONE
	if Input.is_action_pressed("camera_up"):
		position += Vector2(0,-camera_speed)
	
	elif Input.is_action_pressed("camera_down"):
		position += Vector2(0,camera_speed)
		
	if Input.is_action_pressed("camera_left"):
		position += Vector2(-camera_speed,0)
	
	elif Input.is_action_pressed("camera_right"):
		position += Vector2(camera_speed,0)
		
func _process(delta):
	var pos_delta =  move_pos - position
	if dragging: #this dragging stuff needs reworked
		var current_pos = get_global_mouse_position()
		var d = current_pos - org_pos		
		if d != Vector2.ZERO:
			self.position += d * delta * camera_speed * zoom
	if abs(pos_delta) > Vector2.ONE:
		var movement =  pos_delta * delta * camera_speed
		move_pos = move_pos - movement
		position += movement
