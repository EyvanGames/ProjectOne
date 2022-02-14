extends KinematicBody

onready var camera_rig = $CameraRig
onready var camera = $CameraRig/Camera
export var speed = 5.0
export var jump_speed = 10.0
var gravity = 50.0
var velocity = Vector3.ZERO

func _ready():
	camera_rig.set_as_toplevel(true)

func _physics_process(delta):
	run(delta)
	jump()
	camera_motion()
	if Input.is_action_pressed("RMB"):
		aim()

func run(delta):
	var direction = Vector3.ZERO
	direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direction.z = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	direction = direction.normalized()
	if direction != Vector3.ZERO and not Input.is_action_pressed("RMB"):
		$Pivot.look_at(translation + direction, Vector3.UP)
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)
func jump():
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y += jump_speed
func camera_motion():
	var player_pos = global_transform.origin
	camera_rig.global_transform.origin = player_pos
func aim():
	var player_pos = global_transform.origin
	var drop_plane = Plane(Vector3(0, 1, 0), player_pos.y)
	var ray_length = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var cursor_pos = drop_plane.intersects_ray(from, to)
	look_at(cursor_pos, Vector3.UP)
	
