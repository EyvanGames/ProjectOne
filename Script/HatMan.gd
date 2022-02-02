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

func run(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z += 1
	if Input.is_action_pressed("ui_up"):
		direction.z -= 1
	direction = direction.normalized()
	
	if direction != Vector3.ZERO:
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
