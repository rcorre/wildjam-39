extends StaticBody

export(global.Item) var item

func _enter_tree():
	add_to_group("chest")

func _on_interactable_interact(player_interactable):
	print("Player was given a ", global.Item.keys()[item])
	if item == global.Item.FOOD:
		player_interactable.emit_signal("food_pick_up", item)
		queue_free()
	elif item == global.Item.BOMB:
		player_interactable.emit_signal("bomb_pick_up")
		#TODO: Add Small particle explosion
		queue_free()
	else:
		var current_player_weapon = player_interactable.current_weapon
		player_interactable.emit_signal("weapon_pick_up", item)
		item = current_player_weapon
