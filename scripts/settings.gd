extends Node

signal volume_updated

# ------ Music 
var background_volume = -20
var sfx_volume = -20

# ------ Mobile
var mobile_controls = true

# Game Mode
var is_sandbox = true


func _ready():
	if OS.get_real_window_size().x >= ProjectSettings.get_setting("display/window/size/width"):
		mobile_controls = false

func set_background_volume(value):
	background_volume = value
	emit_signal("volume_updated")
	
func set_sfx_volume(value):
	sfx_volume = value
	emit_signal("volume_updated")
