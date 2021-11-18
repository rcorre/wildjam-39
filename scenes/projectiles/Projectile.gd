extends KinematicBody

export(float, 0, 100) var speed := 10.0
export(global.Unit) var owner_unit = global.Unit.ENEMY

func _ready():
	collision_mask = 8 if owner_unit == global.Unit.HERO else 2
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 3
	timer.start()
	timer.connect("timeout", self, "queue_free")

func _physics_process(delta: float):
	var col := move_and_collide(global_transform.basis.z * speed * delta)
	if col:
		col.collider.propagate_call("hurt", [0])
		print("Hit: ", col.collider.name)
		queue_free()
