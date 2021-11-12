extends StaticBody

const CHEST_SCENE := preload("res://props/Chest.tscn")

var selected_prop = null

func _ready():
	connect("input_event", self, "_on_input_event") 
	selected_prop = CHEST_SCENE.instance()
	add_child(selected_prop)

func _on_input_event(_camera: Node, event: InputEvent, position: Vector3, _normal: Vector3, _shape_idx: int):
	if not selected_prop:
		return

	var pos := position.round()  # "snap" to grid

	if event.is_action_pressed("place_prop"):
		place_prop(pos)

	selected_prop.global_transform.origin = pos

func place_prop(pos: Vector3):
	assert(selected_prop)

	for p in get_tree().get_nodes_in_group("prop"):
		if p.global_transform.origin.is_equal_approx(pos) and p != selected_prop:
			return  # already a prop here

	# leave the current prop where it is, create a new one
	selected_prop = CHEST_SCENE.instance()
	add_child(selected_prop)
