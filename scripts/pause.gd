extends MarginContainer

#Queue

func _input(event):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused
		$Sound_menu.hide()


func _on_volume_pressed():
	$Sound_menu.visible = !$Sound_menu.visible
