extends KinematicBody

export(float, 0, 100) var speed := 10.0

func _physics_process(delta: float):
	var col := move_and_collide(global_transform.basis.z * speed * delta)
	if col:
		col.collider.propagate_call("hurt")
		queue_free()
