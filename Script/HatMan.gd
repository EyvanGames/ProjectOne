extends KinematicBody

const SPEED = 5
const UP_DIRECTION = Vector3(0, 1, 0)
var motion = Vector3()

func _physics_process(delta):
	move()

func _process(delta):
	face_forward()

func move():
	if Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up"):
		motion.z = SPEED
	elif Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down"):
		motion.z = -SPEED
	else:
		motion.z = 0

	if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
		motion.x = SPEED
	elif Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		motion.x = -SPEED
	else: motion.x = 0

	move_and_slide(motion, UP_DIRECTION)

func face_forward():
	if not motion.x == 0 or not motion.z == 0:
		look_at(Vector3(-motion.x, 0, -motion.z), UP_DIRECTION)
