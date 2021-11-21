extends AudioStreamPlayer

func play_stream(path: String):
		self.stream = load("res://audio/music/" + path + ".ogg")
		play()

func _ready():
	play_stream("dungeon setup/dungeon_setup")
	Events.connect("ai_entered", self, "play_stream", ["dungeon playthrough/ai_dugeon_playthrough"])
	Events.connect("player_entered", self, "play_stream", ["dungeon playthrough/player_dungeon_playthrough"])
