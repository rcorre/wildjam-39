extends Spatial

const INTERLUDE_SCENE := preload("res://scenes/Interlude.tscn")

onready var dungeonMaster = $DungeonMasterHUD
onready var player = preload("res://scenes/player.tscn").instance()
onready var ai = preload("res://scenes/Hero.tscn").instance()
var main_menu = load("res://scenes/main_menu.tscn").instance()
var props_dup: Node

func on_hero_died(hero):
	print("obj ", hero, " died")
	hero.queue_free()
	if hero == ai:
		print("is ai")
		var interlude := INTERLUDE_SCENE.instance()
		add_child(interlude)
		interlude.connect("tree_exited", self, "start_player_run")
	if hero == player:
		#TODO: overlord comment
		on_player_death()

func on_hero_finished(hero):
	if hero == ai:
		Overlord.say_once(global.overloard_dialogue.FAILURE)
		get_tree().create_timer(6.0).connect("timeout", get_tree(), "change_scene", ["res://scenes/main_menu.tscn"])
	if hero == player:
		#TODO: overlord comment
		on_player_death()

func start_AI_run():
	print("start AI run")
	remove_child(dungeonMaster)
	add_child(ai)
	Events.connect("hero_died", self, "on_hero_died", [ai])
	Events.connect("hero_finished", self, "on_hero_finished", [ai])
	Events.emit_signal("dungeon_entered")
	Events.emit_signal("ai_entered")
	props_dup = $Props.duplicate()


func start_player_run():
	Events.disconnect("hero_died", self, "on_hero_died")
	Events.disconnect("hero_finished", self, "on_hero_finished")
	add_child(player)
	Events.connect("hero_died", self, "on_hero_died", [player])
	Events.connect("hero_finished", self, "on_hero_finished", [player])
	$Props.queue_free()
	add_child(props_dup)
	Events.emit_signal("dungeon_entered")
	Events.emit_signal("player_entered")

func on_player_finished():
	print("Game over, You win!")
	_on_pause_quit() #Use some other scene.

func on_player_death():
	print("Game over....")
	#yield some time
	_on_pause_quit() #Use some other scene.

func _on_player_controler_toggled(player_control):
	if player_control:
		Events.emit_signal("dungeon_entered")
		Events.emit_signal("player_entered")
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
		Events.emit_signal("ai_entered")
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
	#TODO: Overlord comment
	$ready.queue_free()
	start_AI_run()


func _on_menu_pressed():
	Events.emit_signal("pause_pressed")
	get_tree().paused = !get_tree().paused
	if get_node("ready"):
		$ready.visible = !$ready.visible

func _ready():
	if Settings.mobile_controls:
		$place.show()

func _on_Area_body_entered(body):
	if body.is_in_group("hero"):
		Events.emit_signal("hero_finished")
