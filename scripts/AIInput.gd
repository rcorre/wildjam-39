extends Spatial

signal look_towards(position)
signal mobile_look_towards(look_vect)
signal move_towards(move_dir)
signal attack()

onready var nav: Navigation = get_tree().get_nodes_in_group("nav")[0]
onready var exit: Vector3 = get_tree().get_nodes_in_group("exit")[0].global_transform.origin

var current_weapon = global.Item.SWORD
var weapon_locations := {}  # Global.Item -> Vector3
var pause_duration := 1.0
var interacted := {}
var path: PoolVector3Array
var ray := RayCast.new()

var path_debug: ImmediateGeometry

var seek_chest = null

func _ready():
	ray.transform.origin.y = 1.0
	ray.add_exception(get_parent())
	add_child(ray)
	if OS.is_debug_build():
		path_debug = ImmediateGeometry.new()
		add_child(path_debug)

func _process(delta: float):
	if not path_debug:
		return

	path_debug.clear()
	path_debug.begin(Mesh.PRIMITIVE_LINE_STRIP)
	path_debug.set_color(Color.red)
	for p in path:
		p.y += 1  # show it a bit above the map
		path_debug.add_vertex(p)
	path_debug.end()

func _physics_process(delta: float):
	#if pause_duration > 0.0:
	#	pause_duration -= delta
	#	return

	var pos := global_transform.origin

	if seek_chest:
		follow_path()

		if pos.distance_to(seek_chest) < 1.0:
			emit_signal("move_towards", Vector3.ZERO)
			Input.action_press("interact")
			pause_duration = 1.0
			path.resize(0)
			seek_chest = null

		return

	var enemy := nearest_visible("enemy")
	if enemy:
		var vuln: Array = enemy.vulnerable_to()
		if current_weapon in vuln:
			print("AI: weapon will work")
			path.resize(0)
			var target := enemy.global_transform.origin
			emit_signal("look_towards", target)
			if pos.distance_to(target) > 1.0:
				emit_signal("move_towards", pos.direction_to(target))
			else:
				emit_signal("move_towards", Vector3.ZERO)
				emit_signal("attack")
				pause_duration = 0.5
			return
		else:
			print("AI: weapon won't work")
			# see if we can find a weapon to use
			for item in vuln:
				var target = weapon_locations.get(item)
				if target:
					print("AI: backtracking to find %d at %s" % [item, target])
					path = nav.get_simple_path(pos, target)
					seek_chest = target
					return

	var chest := nearest_visible("chest")
	if chest:
		path.resize(0)
		var target := chest.global_transform.origin
		emit_signal("look_towards", target)
		if pos.distance_to(target) > 1.0:
			emit_signal("move_towards", pos.direction_to(target))
		else:
			emit_signal("move_towards", Vector3.ZERO)
			Input.action_press("interact")
			interacted[chest] = true
			pause_duration = 1.0
		return

	if not path:
		print("Finding path to exit")
		path = nav.get_simple_path(pos, exit)
		pause_duration = 1.0

	follow_path()

func follow_path():
	var pos := global_transform.origin
	var target := path[0]
	emit_signal("look_towards", target)
	if pos.distance_to(target) > 0.8:
		emit_signal("move_towards", pos.direction_to(target))
	else:
		path.remove(0)
		pause_duration = 0.5

func nearest_visible(group: String) -> Spatial:
	var nearest: Spatial = null
	var nearest_dist := INF
	var pos := global_transform.origin
	for c in get_tree().get_nodes_in_group(group):
		var s := c as Spatial
		assert(s)
		if s in interacted:
			continue
		var target := s.global_transform.origin
		var dist := pos.distance_to(target)
		if dist < nearest_dist:
			ray.cast_to = ray.to_local(target)
			ray.force_raycast_update()
			if ray.get_collider() == s:
				nearest_dist = dist
				nearest = s
	return nearest

func _on_weapon_pick_up(item: int):
	# remember where we put the old weapon, in case we need it
	print("AI: remember %d is at %s" % [current_weapon, global_transform.origin])
	weapon_locations[current_weapon] = global_transform.origin
	current_weapon = item
