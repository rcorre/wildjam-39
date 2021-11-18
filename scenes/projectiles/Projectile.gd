extends KinematicBody

export(float, 0, 100) var speed := 10.0
export(global.Item) var projectile_weapon_type
var hit_object = false

func _ready():
	custom_queue_free(3)

func _physics_process(delta: float):
	if hit_object:
		return
	var col := move_and_collide(global_transform.basis.z * speed * delta)
	if col:
		print("Hit a : ", col.collider.name)
		col.collider.propagate_call("hurt", [projectile_weapon_type])
		speed = 3
		#$CPUParticles.lifetime = 0.25
		$CollisionShape.disabled = true
		hit_object = true
		custom_queue_free(.25)

func custom_queue_free(wait_time):
	"""
	Prevent yield errors
	"""
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = wait_time
	timer.start()
	timer.connect("timeout", self, "queue_free")
