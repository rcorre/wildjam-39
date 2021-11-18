extends AudioStreamPlayer


func _ready():
	Settings.connect("volume_updated", self, "on_volume_udpated")
	
func on_volume_udpated():
	volume_db = Settings.background_volume

func _on_player_controler_toggled(button_pressed):
	if button_pressed:
		self.stream = load("res://audio/music/dungeon playthrough/player_dungeon_playthrough.ogg")
		play()
	else:
		self.stream = load("res://audio/music/dungeon setup/dungeon_setup.ogg")
		play()


func _on_ai_button_toggled(button_pressed):
	if button_pressed:
		self.stream = load("res://audio/music/dungeon playthrough/ai_dugeon_playthrough.ogg")
		play()
	else:
		self.stream = load("res://audio/music/dungeon setup/dungeon_setup.ogg")
		play()
