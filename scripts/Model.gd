extends Spatial

signal updated_root_motion_direction(direction)

func _on_Player_input_look_towards(position):
	"""
	Update rotation matrix based on look at position
	
	Signal from: player_input / enemy_input
	"""
	var dir_to = global_transform.origin.direction_to(position)
	var target_rad = atan2(dir_to.x, dir_to.z)
	var dif_rad = target_rad - rotation.y 
	
	global_transform.basis = global_transform.basis.rotated(Vector3.UP, dif_rad)

func _on_movement_updated_velocity(velocity):
	"""
	Update walk animation based on velocity;
		transform the velocity relative to the direction our feet are facing 

	Signal from: Movement
	"""
	var local_velocity = global_transform.basis.xform_inv(velocity)
	var blend_position = Vector2(-local_velocity.x, local_velocity.z)
	$AnimationTree.set("parameters/blend_position", blend_position)

func _physics_process(delta):
	var root_motion_origin = $AnimationTree.get_root_motion_transform().origin
	var direction = global_transform.basis.xform(root_motion_origin) / delta

	emit_signal("updated_root_motion_direction", direction)

