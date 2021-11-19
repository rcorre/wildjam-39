extends Control

signal quit

func _input(event):
	raise()
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused

func _on_quit_pressed():
	emit_signal("quit")

