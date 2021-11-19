extends Camera

const ray_length = 20

signal look_towards(position)
signal mobile_look_towards(look_vect)
signal move_towards(move_dir)
signal attack()

const TouchScreenButtonDiameter = 200

onready var mobileMoveBtn = $TouchScreenMoveButton
onready var mobileLookBtn = $RightAnchor/TouchScreenLookButton
onready var right_anchor = $RightAnchor

onready var center_move_btn = Vector2(mobileMoveBtn.global_position.x + mobileMoveBtn.shape.radius,
									mobileMoveBtn.global_position.y + mobileMoveBtn.shape.radius)

onready var center_look_btn = Vector2(mobileLookBtn.global_position.x + mobileLookBtn.shape.radius,
									mobileLookBtn.global_position.y + mobileLookBtn.shape.radius)
var mobile_move_vect := Vector2.ZERO
var mobile_look_vect := Vector2.ZERO

func _ready():
	$Debug/VBoxContainer/Debug/Platform.text = "Platform: " + OS.get_name()
	$Debug/VBoxContainer/Debug/Screen_size1.text = str(OS.get_real_window_size())
	$Debug/VBoxContainer/Debug/Screen_size2.text = str(ProjectSettings.get_setting("display/window/size/width"))
	
	if !Settings.mobile_controls:
		disable_mobile()

	right_anchor.position.x = ProjectSettings.get_setting("display/window/size/width") - (TouchScreenButtonDiameter)

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
	if mobileMoveBtn.is_pressed():
		emit_signal("move_towards", Vector3(mobile_move_vect.x, 0 , mobile_move_vect.y).normalized())
	else:
		emit_signal("move_towards", Vector3.ZERO)
	if mobileLookBtn.is_pressed():
		emit_signal("mobile_look_towards", mobile_look_vect)

func _physics_process(delta):
	$Debug/VBoxContainer/Debug/FPS.text = "FPS: " + str(Engine.get_frames_per_second())
#	mobileLookBtn.position.x = get_viewport().size.x - (TouchScreenButtonDiameter)
	if Settings.mobile_controls:
		mobile_input()
	else:
		keyboard_input()

func _input(event):
	"""
	Update Look at and move vectors based on even position for mobile use
	"""
	if !Settings.mobile_controls:
		return
	if !(event is InputEventScreenDrag or event is InputEventScreenTouch):
		return

	if event.position.y < mobileMoveBtn.position.y:
		return
	if event.position.x <= TouchScreenButtonDiameter:
		mobile_move_vect = (center_move_btn - event.position).normalized()
	if event.position.x > mobileLookBtn.position.x:
		mobile_look_vect = (center_look_btn - event.position).normalized()
	$Debug/VBoxContainer/Debug/event_point.text = str(event.position)

func _on_mobile_controls_toggled(button_pressed):
	Settings.mobile_controls = button_pressed
	if Settings.mobile_controls:
		enable_mobile()
	else:
		disable_mobile()
	
func disable_mobile():
	remove_child(mobileMoveBtn)
	remove_child(right_anchor)

func enable_mobile():
	add_child(mobileMoveBtn)
	add_child(right_anchor)

func _on_attack_pressed():
	emit_signal("attack")

func _on_interact_pressed():
	Input.action_press("interact")


func _on_menu_pressed():
	Events.emit_signal("pause_pressed")
	get_tree().paused = !get_tree().paused
	$TouchScreenMoveButton.visible = !$TouchScreenMoveButton.visible
	$RightAnchor/TouchScreenLookButton.visible = !$RightAnchor/TouchScreenLookButton.visible
	$RightAnchor/attack.visible = !$RightAnchor/attack.visible
	$RightAnchor/interact.visible = !$RightAnchor/interact.visible 
	if !OS.is_debug_build():
		return
	$Debug.visible = !$Debug.visible
