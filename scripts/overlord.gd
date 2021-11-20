extends Control

const RANDOM_INTERVAL := 10.0
const VOICE_PATH := "res://audio/sfx/voice/"

const OPTION_TO_VOICE = {
	global.overloard_dialogue.CHEST_FOOD :[
		["In my day, heros didn't need food", preload("res://audio/sfx/voice/Food_2.wav")],
	],
	global.overloard_dialogue.INVALID_WEAPON :[
		["You fool! It won't work!", preload("res://audio/sfx/voice/WontWork.wav")],
	],
	global.overloard_dialogue.RANDOM :[
		["Mirror, mirror, on the wall, who's <shatters> ... I thought so", preload("res://audio/sfx/voice/Mirror_Mirror_1.wav")],
		["A hero? Here? Already? Who shows up early to a raid?", preload("res://audio/sfx/voice/Hero_Raid_2.wav")],
		["Another hero? Give them a fetch quest or something", preload("res://audio/sfx/voice/Another_Hero_2.wav")],
		["What was I thinking, hiring a dungeon designer on Fiverr?", preload("res://audio/sfx/voice/Fiverr_2.wav")],
		["Bah, I'd do this myself if I weren't so busy doing ... uh ... evil things", preload("res://audio/sfx/voice/Evil_Things_1.wav")],
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
	var timer := Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "say_something_about", [global.overloard_dialogue.RANDOM])
	timer.start(RANDOM_INTERVAL)

func say_something_about(dialogue_option: int, chance: float = 0.25):
	if randf() > chance:
		print("Random voice roll success")
		speak(dialogue_option)
	else:
		print("Random voice skip")

func say_once(opt: int):
	if not opt in already_said:
		already_said[opt] = true
		speak(opt)

func speak(dialogue_option: int):
	if $AnimationPlayer.is_playing() or voice.playing:
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
