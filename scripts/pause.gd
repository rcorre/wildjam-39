extends Control

signal quit

func _input(event):
	if Input.is_action_just_pressed("pause"):
		if $Sound_menu.visible:
			$Sound_menu.hide()
			return
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused
		$Sound_menu.hide()

func _on_volume_pressed():
	$Sound_menu.visible = !$Sound_menu.visible


func _on_quit_pressed():
	emit_signal("quit")

