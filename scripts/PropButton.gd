extends Button

export(PackedScene) var prop_scene: PackedScene

func _pressed():
	Events.emit_signal("prop_selected", prop_scene)

func _ready():
	Events.connect("prop_placed", self, "set_pressed", [false])
