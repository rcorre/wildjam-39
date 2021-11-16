extends StaticBody

export(global.Item) var item

func _on_interactable_interact(player_interactable):
	print("Player was given a ", global.Item.keys()[item])
	if item == global.Item.FOOD:
		player_interactable.emit_signal("food_pick_up", item)
	else:
		player_interactable.emit_signal("weapon_pick_up", item)
	queue_free()
