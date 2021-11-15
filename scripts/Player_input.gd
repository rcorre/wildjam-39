extends Camera

const ray_length = 20

signal look_towards(position)
signal mobile_look_towards(look_vect)
signal move_towards(move_dir)
signal attack()

const TouchScreenButtonDiameter = 200

onready var mobileMoveBtn = $TouchScreenMoveButton
onready var mobileLookBtn = $TouchScreenLookButton

onready var center_move_btn = Vector2($TouchScreenMoveButton.position.x + $TouchScreenMoveButton.shape.radius,
									$TouchScreenMoveButton.position.y + $TouchScreenMoveButton.shape.radius)

onready var center_look_btn = Vector2($TouchScreenLookButton.position.x + $TouchScreenLookButton.shape.radius,
									$TouchScreenLookButton.position.y + $TouchScreenLookButton.shape.radius)
var mobile_controls = true
var mobile_move_vect := Vector2.ZERO
var mobile_look_vect := Vector2.ZERO

func _ready():
	$Debug/VBoxContainer/Platform.text = "Platform: " + OS.get_name()
	$Debug/VBoxContainer/Screen_size.text = str(get_viewport().size)
	mobileLookBtn.position.x = get_viewport().size.x - (TouchScreenButtonDiameter)

func keyboard_input():
	var from = project_ray_origin(get_viewport().get_mouse_position())
	var to = from + project_ray_normal(get_viewport().get_mouse_position()) * ray_length
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to, [], $look_at_plane.collision_layer)
	if result:
		emit_signal("look_towards", result.position)

	var input_vect := Input.get_vector("Right", "Left", "Down", "Up")

	emit_signal("move_towards", Vector3(input_vect.x, 0 , input_vect.y))
	if Input.is_action_just_pressed("attack"):
		emit_signal("attack")
	
func mobile_input():
	$Debug/state_move.text = str(mobileMoveBtn.is_pressed())
	$Debug/state_look.text = str(mobileLookBtn.is_pressed())
	if mobileMoveBtn.is_pressed():
		emit_signal("move_towards", Vector3(mobile_move_vect.x, 0 , mobile_move_vect.y).normalized())
	else:
		emit_signal("move_towards", Vector3.ZERO)
	if mobileLookBtn.is_pressed():
		emit_signal("mobile_look_towards", mobile_look_vect)

func _physics_process(delta):
	$Debug/VBoxContainer/FPS.text = "FPS: " + str(Engine.get_frames_per_second())
	$Debug/VBoxContainer/Screen_size.text = str(get_viewport().size)
#	mobileLookBtn.position.x = get_viewport().size.x - (TouchScreenButtonDiameter)
	if mobile_controls:
		mobile_input()
	else:
		keyboard_input()

func _input(event):
	"""
	Update Look at and move vectors based on even position for mobile use
	"""
	if !mobile_controls:
		return
	if !(event is InputEventScreenDrag or event is InputEventScreenTouch):
		return

	if event.position.y < mobileMoveBtn.position.y:
		return
	if event.position.x <= TouchScreenButtonDiameter:
		mobile_move_vect = (center_move_btn - event.position).normalized()
	if event.position.x > mobileLookBtn.position.x:
		mobile_look_vect = (center_look_btn - event.position).normalized()
	$Debug/VBoxContainer/event_point.text = str(event.position)

func _on_mobile_controls_toggled(button_pressed):
	mobile_controls = button_pressed
	if mobile_controls:
		enable_mobile()
	else:
		disable_mobile()
	
func disable_mobile():
	$Debug/state_look.hide()
	$Debug/state_move.hide()
	remove_child(mobileMoveBtn)
	remove_child(mobileLookBtn)

func enable_mobile():
	$Debug/state_look.show()
	$Debug/state_move.show()
	add_child(mobileMoveBtn)
	add_child(mobileLookBtn)

func _on_attack_pressed():
	emit_signal("attack")

func _on_interact_pressed():
	Input.action_press("interact")
