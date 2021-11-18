extends KinematicBody

export(PackedScene) var projectile_scene: PackedScene

const GRAVITY := -9.8
const ATTACK_DISTANCE := 5.0

enum LifeState {
	ALIVE,
	DEAD,
}
export(global.Enemy_type) var enemy_type

var damage_table = [
	[global.Item.SWORD, global.Item.BOW],	#Spider
	[global.Item.WAND],						#Slime
	[global.Item.MACE],						#Skeleton
]


onready var aggro_area: Area = $AggroArea
onready var anim_tree: AnimationTree = $AnimationTree
onready var projectile_point: Spatial = $SpitPoint

var velocity := Vector3.ZERO



func _physics_process(delta: float):
	anim_tree.set("parameters/move/blend_position", 0.0)
	# should be at most 1 overlapping body
	for b in aggro_area.get_overlapping_bodies():
		var pos: Vector3 = b.global_transform.origin
		if global_transform.origin.distance_to(pos) < ATTACK_DISTANCE:
			# in range to attack
			if projectile_scene and not anim_tree.get("parameters/attack/active"):
				anim_tree.set("parameters/attack/active", true)
				var projectile: Spatial = projectile_scene.instance()
				projectile.global_transform = projectile_point.global_transform
				get_tree().current_scene.add_child(projectile)
		else:
			# look and move toward player
			global_transform.basis = global_transform.looking_at(pos, Vector3.UP).basis
			rotate_y(PI) # looking_at points us in the opposite direction
			anim_tree.set("parameters/move/blend_position", 1.0)
	
	var root_motion_origin := anim_tree.get_root_motion_transform().origin
	velocity = global_transform.basis.xform(root_motion_origin) / delta
	velocity = move_and_slide(velocity)

func hurt(player_weapon):
	if !(player_weapon in damage_table[enemy_type]):
		print("This weapon can't hit this unit", damage_table[enemy_type])
		return
		
	anim_tree.set("parameters/life_state/current", LifeState.DEAD)
	get_tree().create_timer(5.0).connect("timeout", self, "queue_free")
