extends KinematicBody

const GRAVITY := 9.8
const ACCEL := 100.0 #12 50(mech)
export(int) var MAX_SPEED := 5.0 #6(Mech) Max speed is fixed to root motion speed

var velocity := Vector3.ZERO
var move_dir := Vector3.ZERO

signal updated_velocity(velocity)

func _on_Player_input_move_towards(_dir):
	"""
	Signal from: player_input
	"""
	move_dir = _dir * MAX_SPEED

func update_velocity(delta):
	"""
	Accelerate towards desired velocity:
		Real speed is based on animation, this velocity is input for blendtree.
	"""
	velocity.x = move_toward(velocity.x, move_dir.x, ACCEL * delta)
#	velocity.y -= GRAVITY * delta
	velocity.z = move_toward(velocity.z, move_dir.z, ACCEL * delta)
	emit_signal("updated_velocity", velocity)

func _physics_process(delta):
	update_velocity(delta)



func _on_Model_updated_root_motion_direction(direction):
	"""
	Signal from: Model
	"""
#	direction.y = -GRAVITY
	velocity = move_and_slide(direction, Vector3.UP)


