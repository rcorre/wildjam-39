extends Control

signal quit

var button_hover = load("res://audio/sfx/menu/button_hover.wav")

func _ready():
	Events.connect("pause_pressed", self, "on_pause_pressed")

func on_pause_pressed():
	visible = !get_tree().paused

func _on_quit_pressed():
	get_tree().paused = false
	emit_signal("quit")



func _on_btn_mouse_entered():
	$sfx.stream = button_hover
	$sfx.play()
