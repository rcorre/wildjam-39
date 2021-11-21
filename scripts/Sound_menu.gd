extends MarginContainer

func _ready():
	$VBoxContainer/background_music/background.value = Settings.get_background_volume()
	$VBoxContainer/sfx_music/sfx.value = Settings.get_sfx_volume()

func _on_background_value_changed(value: float):
	Settings.set_background_volume(value -2)

func _on_SFX_value_changed(value: float):
	Settings.set_sfx_volume(value - 2)
