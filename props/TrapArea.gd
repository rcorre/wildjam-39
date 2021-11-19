extends Area

signal tripped()

func _ready():
	connect("body_entered", self, "_on_body_entered", [], CONNECT_ONESHOT)

func _on_body_entered(body: Node):
	Overlord.say_something_about(global.overloard_dialogue.TRAP)
	body.propagate_call("hurt", [0])
	emit_signal("tripped")
