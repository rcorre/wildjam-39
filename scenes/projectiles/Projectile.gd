extends KinematicBody

export(float, 0, 100) var speed := 10.0
export(global.Unit) var owner_unit = global.Unit.ENEMY

func _ready():
	collision_mask = 8 if owner_unit == global.Unit.HERO else 2

func _physics_process(delta: float):
	var col := move_and_collide(global_transform.basis.z * speed * delta)
	if col:
		col.collider.propagate_call("hurt")
		print("Hit: ", col.collider.name)
		queue_free()
