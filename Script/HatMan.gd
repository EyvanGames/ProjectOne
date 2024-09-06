extends CharacterBody3D

@onready var camera_rig = $CameraRig
@onready var camera = $CameraRig/Camera3D
@onready var anim_node = $Armature/Skeleton3D/AnimationTree
@export var jump_speed:float = 10.0
var direction = Vector3.ZERO
var velociting = Vector3.ZERO
var gravity:float = 50.0
var movement_speed:float = 0.0
var walk_speed:float = 1.5
var run_speed:float = 5.0
var acceleration = 6

func _ready():
	camera_rig.set_as_top_level(true)

func _physics_process(delta):
	run(delta)
	jump()
	camera_motion()
	if Input.is_action_pressed("RMB"):
		anim_node.set("parameters/guard_transition/current", 0)
		aim()
	else:
		anim_node.set("parameters/guard_transition/current", 1)

func run(delta):
	direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direction.z = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	direction = direction.normalized()
	if Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_up"):
		if Input.is_action_pressed("sprint") && anim_node.get("parameters/guard_transition/current") == 1:
			movement_speed = run_speed
			anim_node.set("parameters/move_blend/blend_amount", lerp(anim_node.get("parameters/move_blend/blend_amount") , 1.0, delta * acceleration))
		else:
			movement_speed = walk_speed
			anim_node.set("parameters/move_blend/blend_amount", lerp(anim_node.get("parameters/move_blend/blend_amount") , 0.0, delta * acceleration))
	else:
		anim_node.set("parameters/move_blend/blend_amount", lerp(anim_node.get("parameters/move_blend/blend_amount") , -1.0, delta * acceleration))
		movement_speed = 0
	if direction != Vector3.ZERO and not Input.is_action_pressed("RMB"):
		look_at(position + direction, Vector3.UP)
	
	velociting.x = direction.x * movement_speed
	velociting.z = direction.z * movement_speed
	velociting.y -= gravity * delta
	set_velocity(velociting)
	set_up_direction(Vector3.UP)
	move_and_slide()
	velociting = velociting

func jump():
	if is_on_floor() and Input.is_action_pressed("jump"):
		velociting.y += jump_speed
		anim_node.set("parameters/jump/active", true)
		anim_node.set("parameters/guard_transition/current", 1)
	
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
