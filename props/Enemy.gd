extends KinematicBody

const GRAVITY := -9.8
const MIN_DISTANCE := 1.0

onready var aggro_area: Area = $AggroArea
onready var anim_tree: AnimationTree = $AnimationTree

var velocity := Vector3.ZERO

func _physics_process(delta: float):
	anim_tree.set("parameters/move/blend_position", 0.0)
	# should be at most 1 overlapping body
	for b in aggro_area.get_overlapping_bodies():
		var pos: Vector3 = b.global_transform.origin
		if global_transform.origin.distance_to(pos) < MIN_DISTANCE:
			break  # too close
		global_transform.basis = global_transform.looking_at(pos, Vector3.UP).basis
		rotate_y(PI) # looking_at points us in the opposite direction
		anim_tree.set("parameters/move/blend_position", 1.0)
	
	var root_motion_origin := anim_tree.get_root_motion_transform().origin
	velocity = global_transform.basis.xform(root_motion_origin) / delta
	velocity = move_and_slide(velocity)
