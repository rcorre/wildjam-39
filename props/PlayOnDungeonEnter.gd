extends AnimationPlayer

export(String) var anim_name := "init"

func _ready():
	Events.connect("dungeon_entered", self, "play", [anim_name])
