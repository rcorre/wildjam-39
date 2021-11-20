extends Control

const VOICE_PATH := "res://audio/sfx/voice/"

const OPTION_TO_VOICE = {
	global.overloard_dialogue.CHEST_WEAPON :[
		["...", null],
	],
	global.overloard_dialogue.CHEST_FOOD :[
		["Did that just heal you?", null],
		["Back in my day heros didn't need food", null],
	],
	global.overloard_dialogue.INVALID_WEAPON :[
		["You fool! It won't work!", preload("res://audio/sfx/voice/WontWork.wav")],
	],
	global.overloard_dialogue.RANDOM :[
		["Complaining about what the player does", null],
		["You're not very good at this game", null],
	],
	global.overloard_dialogue.TRAP :[
		["You forgot you placed that?", null],
		["Ouch", null],
		["That must hurt", null],
	],
	global.overloard_dialogue.PLACE_WEAPON: [
		["Oh, let's just give them weapons, shall we?", preload("res://audio/sfx/voice/GiveThemWeapons.wav")]
	],
	global.overloard_dialogue.PLACE_FOOD: [
		["This is a dungeon, not a dinner party!", preload("res://audio/sfx/voice/DinnerParty.wav")],
	],
	global.overloard_dialogue.PLACE_TRAP :[
		["Hope you remember where you put that...", preload("res://audio/sfx/voice/RememberTrap.wav")],
	],
	global.overloard_dialogue.PLACE_SKELETON: [
		["A skeleton? They'll shatter it with a single blow from a mace", preload("res://audio/sfx/voice/Skeleton_2.wav")],
	],
	global.overloard_dialogue.PLACE_SLIME: [
		["If a mage comes through, that slime is no more dangerous than a jar of jam!", preload("res://audio/sfx/voice/Jar_of_Jam_2.wav")],
	],
	global.overloard_dialogue.PLACE_SPIDER: [
		["You think those spider will stand up to a skilled archer?", preload("res://audio/sfx/voice/Spiders_2.wav")],
	],
}

onready var voice: AudioStreamPlayer = $Voice

var already_said := {} # global.overlord_dialogue -> bool

func _ready():
	var texture = $Viewport.get_texture()
	$MarginContainer/HBoxContainer/TextureRect.texture = texture

func say_something_about(dialogue_option: int, chance: float = 0.25):
	if randf() > chance:
		speak(dialogue_option)

func say_once(opt: int):
	if not opt in already_said:
		already_said[opt] = true
		speak(opt)

func speak(dialogue_option: int):
	if $AnimationPlayer.is_playing():
		return

	$AnimationPlayer.play("animate")
	var text_list = OPTION_TO_VOICE[dialogue_option]
	var dialogue = text_list[randi() % text_list.size()]
	var text: String = dialogue[0]
	var stream: AudioStream = dialogue[1]
	print(text)
	$MarginContainer/HBoxContainer/Label.text = text
	if stream:
		voice.stream = stream
		voice.play()
	yield(get_tree().create_timer(3), "timeout")

	#Prevent multiple returned yields from restarting animation.
	if $AnimationPlayer.is_playing():
		return
	if $MarginContainer/ColorRect.modulate.a == 0:
		return
	$AnimationPlayer.play_backwards("animate")
