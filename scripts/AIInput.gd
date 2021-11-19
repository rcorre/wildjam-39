extends Spatial

signal look_towards(position)
signal mobile_look_towards(look_vect)
signal move_towards(move_dir)
signal attack()

onready var nav: Navigation = get_tree().get_nodes_in_group("nav")[0]
onready var exit: Vector3 = get_tree().get_nodes_in_group("exit")[0].global_transform.origin

var interacted := {}
var path: PoolVector3Array
var ray := RayCast.new()

var path_debug: ImmediateGeometry

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
	var pos := global_transform.origin

	var enemy := nearest_visible("enemy")
	if enemy:
		path.resize(0)
		var target := enemy.global_transform.origin
		emit_signal("look_towards", target)
		if pos.distance_to(target) > 1.0:
			emit_signal("move_towards", pos.direction_to(target))
		else:
			emit_signal("move_towards", Vector3.ZERO)
			emit_signal("attack")
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
		return

	if not path:
		print("Pathfinding update")
		path = nav.get_simple_path(pos, exit)

	var target := path[0]
	emit_signal("look_towards", target)
	if pos.distance_to(target) > 0.8:
		emit_signal("move_towards", pos.direction_to(target))
	else:
		path.remove(0)

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
