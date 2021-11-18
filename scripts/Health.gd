extends Area

export(int) var health = 3

signal died()

func _ready():
	for heart in range(health - 1):
		$HealthBar.add_child($HealthBar/heart.duplicate())


func hurt(_ignore):
	health -= 1
	update_ui()
	if health <= 0:
		emit_signal("died") #Event buss

func _on_interactable_detection_food_pick_up(item):
	health += 1
	update_ui()

func update_ui():
	for i in range($HealthBar.get_child_count()):
		var c: Control = $HealthBar.get_child(i)
		c.modulate = Color.red if i < health else Color.gray


func _on_interactable_detection_bomb_pick_up():
	hurt(0)
	#TODO: Add Overload comment
