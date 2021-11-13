extends StaticBody

var selected_prop = null

func _ready():
	connect("input_event", self, "_on_input_event")
	Events.connect("prop_selected", self, "_on_prop_selected")

func _on_prop_selected(scene: PackedScene):
	if selected_prop:
		selected_prop.queue_free()
	selected_prop = scene.instance()
	add_child(selected_prop)

func _on_input_event(_camera: Node, event: InputEvent, position: Vector3, _normal: Vector3, _shape_idx: int):
	if not selected_prop:
		return

	var pos := position.round()  # "snap" to grid
	selected_prop.global_transform.origin = pos

	if event.is_action_pressed("place_prop"):
		place_prop(pos)

func place_prop(pos: Vector3):
	assert(selected_prop)

	for p in get_tree().get_nodes_in_group("prop"):
		if p.global_transform.origin.is_equal_approx(pos) and p != selected_prop:
			return  # already a prop here

	selected_prop = null
	Events.emit_signal("prop_placed")
