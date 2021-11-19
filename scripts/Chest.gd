extends StaticBody

signal opened()

onready var anim: AnimationPlayer = $AnimationPlayer

export(global.Item) var item

func _enter_tree():
	add_to_group("chest")

func _on_interactable_interact(player_interactable):
	print("Player was given a ", global.Item.keys()[item])
	if item == global.Item.FOOD:
		Overlord.say_something_about(global.overloard_dialogue.CHEST_FOOD)
		player_interactable.emit_signal("food_pick_up", item)
		$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
		emit_signal("opened")
	elif item == global.Item.BOMB:
		player_interactable.emit_signal("bomb_pick_up")
		Overlord.say_something_about(global.overloard_dialogue.TRAP)
		$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
		emit_signal("opened")
	else:
		var current_player_weapon = player_interactable.current_weapon
		Overlord.say_something_about(global.overloard_dialogue.CHEST_WEAPON)
		player_interactable.emit_signal("weapon_pick_up", item)
		item = current_player_weapon
		emit_signal("opened")

	if is_in_group("chest"):
		remove_from_group("chest")
	$sfx.play()
	anim.play("Open")
	yield(get_tree().create_timer(2), "timeout")
	anim.play_backwards("Open")
	
func _on_animation_finished(animation):
	queue_free()
