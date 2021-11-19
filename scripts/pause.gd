extends Control

signal quit

func _ready():
	Events.connect("pause_pressed", self, "on_pause_pressed")

func on_pause_pressed():
	visible = !get_tree().paused

func _on_quit_pressed():
	emit_signal("quit")

