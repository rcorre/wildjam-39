extends StaticBody

signal opened()

onready var anim: AnimationPlayer = $AnimationPlayer

export(global.Item) var item

var interacted := false

func _enter_tree():
	add_to_group("chest")

func _on_interactable_interact(player_interactable):
	print("Player was given a ", global.Item.keys()[item])
	if item == global.Item.FOOD and not interacted:
		interacted = true
		player_interactable.emit_signal("food_pick_up", item)
		emit_signal("opened")
	elif item == global.Item.BOMB and not interacted:
		interacted = true
		player_interactable.emit_signal("bomb_pick_up")
		emit_signal("opened")
	else:
		var current_player_weapon = player_interactable.current_weapon
		player_interactable.emit_signal("weapon_pick_up", item)
		item = current_player_weapon
		emit_signal("opened")

	remove_from_group("chest")
	anim.play("Open")
