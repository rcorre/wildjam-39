extends Spatial

onready var dungeonMaster = $DungeonMasterHUD
onready var player = preload("res://scenes/player.tscn").instance()
onready var ai = preload("res://scenes/Hero.tscn").instance()
var main_menu = load("res://scenes/main_menu.tscn").instance()
var current_hero = global.Hero.PLAYER
var map_dup

func _ready():
	Events.connect("hero_died", self, "on_hero_died")
	
func on_hero_died():
	if current_hero == global.Hero.AI:
		start_player_run()
	if current_hero == global.Hero.PLAYER:
		on_player_death()

func start_AI_run():
	current_hero = global.Hero.AI
	remove_child(dungeonMaster)
	add_child(ai)
	Events.emit_signal("dungeon_entered")
	map_dup = $map.duplicate()
	#TODO: overlord comment

func start_player_run():
	current_hero = global.Hero.PLAYER
	remove_child(ai)
	add_child(player)
	$map.queue_free()
	add_child(map_dup)
	Events.emit_signal("dungeon_entered")
	#TODO: overlord comment

func on_player_death():
	print("Game over....")
	#TODO: overlord comment

func _on_player_controler_toggled(player_control):
	if player_control:
		Events.emit_signal("dungeon_entered")
		$Debug/ai_button.hide()
		remove_child(dungeonMaster)
		add_child(player)
	else:
		remove_child(player)
		$Debug/ai_button.show()
		add_child(dungeonMaster)

func _on_ai_toggled(on: bool):
	if on:
		Events.emit_signal("dungeon_entered")
		remove_child(dungeonMaster)
		$Debug/player_controler.hide()
		add_child(ai)
	else:
		remove_child(ai)
		$Debug/player_controler.show()
		add_child(dungeonMaster)

func _on_pause_quit():
	get_tree().root.add_child(main_menu)
	queue_free()

func _on_ready_pressed():
	$ready.hide()
	start_AI_run()
