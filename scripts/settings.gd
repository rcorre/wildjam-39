extends Node

signal volume_updated

# ------ Music 
var background_volume = -20
var sfx_volume = -20

# ------ Keys


# Game Mode
var is_sandbox = true


func set_background_volume(value):
	background_volume = value
	emit_signal("volume_updated")
	
func set_sfx_volume(value):
	sfx_volume = value
	emit_signal("volume_updated")
