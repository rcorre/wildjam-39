extends Camera

const ray_length = 20

signal look_towards(position)
signal move_towards(move_dir)

onready var center_pos = Vector2($TouchScreenButton.position.x + $TouchScreenButton.shape.radius,
									$TouchScreenButton.position.y + $TouchScreenButton.shape.radius)

var input_vect := Vector2.ZERO #change name b/c it's used twice

func _ready():
	#TODO: If in HTML show touchScreenButton else ignore.
	pass

func player_input():
	var from = project_ray_origin(get_viewport().get_mouse_position())
	var to = from + project_ray_normal(get_viewport().get_mouse_position()) * ray_length
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to, [], 1)
	if result:
		emit_signal("look_towards", result.position)

	var input_vect := Input.get_vector("Right", "Left", "Down", "Up")
	if input_vect:
		print("WASD: ", input_vect)
	emit_signal("move_towards", Vector3(input_vect.x, 0 , input_vect.y))
	
func _physics_process(delta):
	player_input()
	if $TouchScreenButton.is_pressed():
		emit_signal("move_towards", Vector3(input_vect.x, 0 , input_vect.y).normalized())

func _input(event):
	if !(event is InputEventScreenDrag or event is InputEventScreenTouch):
		return

	input_vect = (center_pos - event.position).normalized() if $TouchScreenButton.is_pressed() else Vector2.ZERO
#	print("event_pos: ",event.position, " Center: ", center_pos, " actual-Pos: ", $TouchScreenButton.position, " Vec: ",  input_vect) #Diameter
