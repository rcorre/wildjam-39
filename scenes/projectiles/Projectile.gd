extends KinematicBody

export(float, 0, 100) var speed := 10.0
export(global.Item) var projectile_weapon_type

func _ready():
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 3
	timer.start()
	timer.connect("timeout", self, "queue_free")

func _physics_process(delta: float):
	var col := move_and_collide(global_transform.basis.z * speed * delta)
	if col:
		print("Hit a : ", col.collider.name)
		col.collider.propagate_call("hurt", [projectile_weapon_type])
		speed = 3
		$CPUParticles.lifetime = 0.25
		yield(get_tree().create_timer(0.25), "timeout")
		queue_free()
