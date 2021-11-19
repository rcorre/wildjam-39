extends Control

func _ready():
	var texture = $Viewport.get_texture()
	$MarginContainer/HBoxContainer/TextureRect.texture = texture
var option_to_text_list = {
	global.overloard_dialogue.CHEST_WEAPON :[
		"..."
	],
	global.overloard_dialogue.CHEST_FOOD :[
		"Did that just heal you?",
		"Back in my day heros didn't need food",
	],
	global.overloard_dialogue.INVALID_WEAPON :[
		"You can't use that weapon to kill that thing! Find something else.",
		"Did I tell you to find a different weapon?",
		"Good luck with that",
		"Why are you even trying with that weapon... Find something else",
	],
	global.overloard_dialogue.RANDOM :[
		"Complaining about what the player does",
		"You're not very good at this game",
	],
	global.overloard_dialogue.TRAP :[
		"You forgot you placed that?",
		"Ouch",
		"That must hurt",
	],
}

func say_something_about(dialogue_option):
#	if randi() % 4 != 0: #25% chance to say thing
#		return
	if $AnimationPlayer.is_playing():
		return

	$AnimationPlayer.play("animate")
	var text_list = option_to_text_list[dialogue_option]
	var dialogue = text_list[randi() % text_list.size()]
	print(dialogue)
	$MarginContainer/HBoxContainer/Label.text = dialogue
	yield(get_tree().create_timer(3), "timeout")

	#Prevent multiple returned yields from restarting animation.
	if $AnimationPlayer.is_playing():
		return
	if $MarginContainer.modulate.a == 0:
		return
	$AnimationPlayer.play_backwards("animate")
