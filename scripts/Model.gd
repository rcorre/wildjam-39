extends Spatial

signal updated_root_motion_direction(direction)

var tmp = {
	global.Item.MACE : {"packed":1, "Animation": global.Item.MACE}
}


func _on_Player_input_look_towards(position : Vector3):
	"""
	Update rotation matrix based on look at position
	
	Signal from: player_input / enemy_input
	"""
	var dir_to = global_transform.origin.direction_to(position)
	var target_rad = atan2(dir_to.x, dir_to.z)
	var dif_rad = target_rad - rotation.y 
	
	global_transform.basis = global_transform.basis.rotated(Vector3.UP, dif_rad)

func _on_Player_input_mobile_look_towards(look_vect : Vector2):
	"""
	Update rotation matrix based on a directional vector
	
	Signal from: player_input
		(Only for mobile controles)
	"""
	var target_rad = atan2(look_vect.x, look_vect.y)
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

	$AnimationTree.set("parameters/move/blend_position", blend_position)

func _physics_process(delta):
	var root_motion_origin = $AnimationTree.get_root_motion_transform().origin
	var direction = global_transform.basis.xform(root_motion_origin) / delta

	emit_signal("updated_root_motion_direction", direction)


func _on_Player_input_attack():
	$AnimationTree.set("parameters/attack/active", true)

export(PackedScene) var projectile_scene: PackedScene
export(PackedScene) var projectile_scene2: PackedScene
onready var projectile_point: Spatial = $projectilePoint
func projectile_attack():
	var projectile: Spatial = projectile_scene.instance()
	projectile.global_transform = projectile_point.global_transform
	get_tree().current_scene.add_child(projectile)

onready var weapons = [$Armature/Skeleton/BoneAttachment/mace,$Armature/Skeleton/Bow, $Armature/Skeleton/BoneAttachment/wand]
func _on_interactable_detection_weapon_pick_up(weapon):
	"""
	Enable weapon mesh
	Set current weapon value in AnimationTree for future one_shot
	"""
	$Armature/Skeleton/left_hand.stop()
	$Armature/Skeleton/right_hand.stop()
	for mesh in weapons:
		mesh.hide()
	weapons[weapon].show()
	$AnimationTree.set("parameters/attack_weapon/current", weapon)
	if weapon == global.Item.BOW:
		$Armature/Skeleton/left_hand.start()
		$Armature/Skeleton/right_hand.start()



