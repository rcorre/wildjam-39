extends Node

# ------ Mobile
var mobile_controls = true

# Game Mode
var is_sandbox = true

func _ready():
	if OS.get_real_window_size().x >= ProjectSettings.get_setting("display/window/size/width"):
		mobile_controls = false

func get_background_volume() -> float:
	var bus := AudioServer.get_bus_index("Music")
	return AudioServer.get_bus_volume_db(bus)

func set_background_volume(value: float):
	var bus := AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus, value)

func get_sfx_volume() -> float:
	var bus := AudioServer.get_bus_index("SFX")
	return AudioServer.get_bus_volume_db(bus)
	
func set_sfx_volume(value: float):
	var bus := AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus, value)
