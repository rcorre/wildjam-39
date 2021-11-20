extends KinematicBody

export(PackedScene) var projectile_scene: PackedScene

const GRAVITY := -9.8
const ATTACK_DISTANCE := 5.0
const GROUP := "enemy"
const TURN_RATE := 5.0

signal died

enum LifeState {
	ALIVE,
	DEAD,
}
var current_state = LifeState.ALIVE
export(global.Enemy_type) var enemy_type

var damage_table = [
	[global.Item.SWORD, global.Item.BOW],	#Spider
	[global.Item.WAND],						#Slime
	[global.Item.MACE],						#Skeleton
]


onready var aggro_area: Area = $AggroArea
onready var anim_tree: AnimationTree = $AnimationTree
onready var projectile_point: Spatial = $SpitPoint

# for now, just reuse the placement sound as the death sound
onready var die_sound: AudioStreamPlayer = $sfx
onready var ineffective_sound := AudioStreamPlayer.new()

var velocity := Vector3.ZERO

func _enter_tree():
	add_to_group(GROUP)

func _ready():
	# don't block the mouse during placement
	input_ray_pickable = false
	ineffective_sound.stream = preload("res://audio/sfx/weapons/ineffective_attack.wav")
	ineffective_sound.bus = "SFX"
	add_child(ineffective_sound)

func _physics_process(delta: float):
	anim_tree.set("parameters/move/blend_position", 0.0)
	# should be at most 1 overlapping body
	if current_state == LifeState.DEAD:
		return
	for b in aggro_area.get_overlapping_bodies():
		var pos: Vector3 = b.global_transform.origin
		# move toward player
		# looking_at points us in the opposite direction
		var look_y := global_transform.looking_at(pos, Vector3.UP).basis.get_euler().y + PI
		rotation.y = lerp_angle(rotation.y, look_y, TURN_RATE * delta)
		if global_transform.origin.distance_to(pos) < ATTACK_DISTANCE:
			# in range to attack
			if projectile_scene and not anim_tree.get("parameters/attack/active"):
				anim_tree.set("parameters/attack/active", true)
				var projectile: Spatial = projectile_scene.instance()
				projectile.global_transform = projectile_point.global_transform
				get_tree().current_scene.add_child(projectile)
		else:
			# Move towrads player
			anim_tree.set("parameters/move/blend_position", 1.0)
	
	var root_motion_origin := anim_tree.get_root_motion_transform().origin
	velocity = global_transform.basis.xform(root_motion_origin) / delta
	velocity.y = GRAVITY
	velocity = move_and_slide(velocity)

func hurt(player_weapon):
	if !(player_weapon in damage_table[enemy_type]):
		Overlord.say_something_about(global.overloard_dialogue.INVALID_WEAPON)
		ineffective_sound.play()
		print(global.Item.keys()[player_weapon], " can't hit this unit, need", damage_table[enemy_type])
		return
		
	if current_state == LifeState.DEAD:
		return
	current_state = LifeState.DEAD
	
	if die_sound:
		die_sound.play()
	anim_tree.set("parameters/life_state/current", LifeState.DEAD)
	get_tree().create_timer(5.0).connect("timeout", self, "queue_free")
	remove_from_group(GROUP)
	emit_signal("died")
	collision_layer = 0
	collision_mask = 0

func vulnerable_to() -> Array:
	return damage_table[enemy_type]

func _on_placed():
	match enemy_type:
		global.Enemy_type.SPIDER:
			Overlord.say_once(global.overloard_dialogue.PLACE_SPIDER)
		global.Enemy_type.SLIME:
			Overlord.say_once(global.overloard_dialogue.PLACE_SLIME)
		global.Enemy_type.SKELETON:
			Overlord.say_once(global.overloard_dialogue.PLACE_SKELETON)
