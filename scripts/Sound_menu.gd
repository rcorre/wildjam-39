extends MarginContainer


func _ready():
	$VBoxContainer/background_music/background.value = Settings.background_volume
	$VBoxContainer/sfx_music/sfx.value = Settings.sfx_volume

func _on_background_value_changed(value):
	Settings.set_background_volume(value)

func _on_SFX_value_changed(value):
	Settings.set_sfx_volume(value)
