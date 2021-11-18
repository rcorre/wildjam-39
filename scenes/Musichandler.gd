extends AudioStreamPlayer

var index = 1

#func _process(delta):
#	if index == 1:
#		#BUILD
#		stream.resource_path = "res://audio/music/dungeon setup/dungeon_setup.ogg"
#	elif index == 2:
#		#AI
#		stream.resource_path = "res://audio/music/dungeon playthrough/ai_dugeon_playthrough.ogg"
#	else:
#		#PLAYER
#		stream.resource_path = "res://audio/music/dungeon playthrough/player_dungeon_playthrough.ogg"

func _ready():
	print(str(get_stream()))

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
