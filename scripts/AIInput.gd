extends Camera

signal look_towards(position)
signal mobile_look_towards(look_vect)
signal move_towards(move_dir)
signal attack()

func _physics_process(delta):
	#emit_signal("look_towards", result.position)
	emit_signal("move_towards", Vector3(10, 0, 10))
	#if Input.is_action_just_pressed("attack"):
	#	emit_signal("attack")
	#Input.action_press("interact")

