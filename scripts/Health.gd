extends Area

export(int) var health = 3
onready var starting_health = health

signal died()

func _ready():
	for heart in range(health - 1):
		$HealthBar.add_child($HealthBar/heart.duplicate())
	Events.connect("pause_pressed", self, "on_pause_pressed")
	
func on_pause_pressed():
	$HealthBar.visible = !$HealthBar.visible

func hurt(_ignore):
	health -= 1
	update_ui()
	if health == 0:
		emit_signal("died")
		# give a little time to show the character dying
		get_tree().create_timer(1.0).connect("timeout", Events, "emit_signal", ["hero_died"])

func _on_interactable_detection_food_pick_up(item):
	health += 1
	update_ui()

func update_ui():
	for i in range($HealthBar.get_child_count()):
		var c: Control = $HealthBar.get_child(i)
		c.modulate = Color.red if i < health else Color.gray


func _on_interactable_detection_bomb_pick_up():
	hurt(0)
	Overlord.say_something_about(global.overloard_dialogue.TRAP)
