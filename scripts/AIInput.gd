extends Spatial

signal look_towards(position)
signal mobile_look_towards(look_vect)
signal move_towards(move_dir)
signal attack()

var interacted := {}

func _physics_process(delta):
	var pos := global_transform.origin

	var enemy := nearest_visible("enemy")
	if enemy:
		var target := enemy.global_transform.origin
		emit_signal("look_towards", target)
		if pos.distance_to(target) > 1.0:
			emit_signal("move_towards", pos.direction_to(target))
		else:
			emit_signal("move_towards", Vector3.ZERO)
			emit_signal("attack")

	var chest := nearest_visible("chest")
	if chest:
		var target := chest.global_transform.origin
		emit_signal("look_towards", target)
		if pos.distance_to(target) > 1.0:
			emit_signal("move_towards", pos.direction_to(target))
		else:
			emit_signal("move_towards", Vector3.ZERO)
			Input.action_press("interact")
			interacted[chest] = true

	#if Input.is_action_just_pressed("attack"):
	#	emit_signal("attack")

func nearest_visible(group: String) -> Spatial:
	var nearest: Spatial = null
	var nearest_dist := INF
	var pos := global_transform.origin
	for c in get_tree().get_nodes_in_group(group):
		var s := c as Spatial
		assert(s)
		if s in interacted:
			continue
		var dist := pos.distance_to(s.global_transform.origin)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = s
	return nearest
