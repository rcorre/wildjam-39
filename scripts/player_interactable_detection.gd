extends Area

var material : Material = load("res://assets/material/player_icon.tres")

func _process(delta):
	var interactables = get_overlapping_areas()

	if !interactables:
		$icon.hide()
		return

	$icon.show()
		
	if Input.is_action_just_pressed("interact"):
		interactables[0].emit_signal("interact")
		return

	for interactable in interactables:
		material.albedo_texture = interactable.icon
		return
	
		
