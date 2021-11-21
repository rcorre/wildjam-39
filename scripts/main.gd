extends Spatial

onready var dungeonMaster = $DungeonMasterHUD
onready var player = preload("res://scenes/player.tscn").instance()
onready var ai = preload("res://scenes/Hero.tscn").instance()
var main_menu = load("res://scenes/main_menu.tscn").instance()
var map_dup

func on_hero_died(hero):
	if hero == ai:
		#TODO: overlord comment
		start_player_run()
	if hero == player:
		#TODO: overlord comment
		on_player_death()

func on_hero_finished(hero):
	if hero == ai:
		#TODO: overlord comment
		start_player_run()
	if hero == player:
		#TODO: overlord comment
		on_player_death()
	
func start_AI_run():
	remove_child(dungeonMaster)
	add_child(ai)
	Events.connect("hero_died", self, "on_hero_died", [ai])
	Events.connect("hero_finished", self, "on_hero_finished", [ai])
	Events.emit_signal("dungeon_entered")
	map_dup = $map.duplicate()


func start_player_run():
	remove_child(ai)
	Events.disconnect("hero_died", self, "on_hero_died")
	Events.disconnect("hero_finished", self, "on_hero_finished")
	add_child(player)
	Events.connect("hero_died", self, "on_hero_died", [player])
	Events.connect("hero_finished", self, "on_hero_finished", [player])
	$map.queue_free()
	add_child(map_dup)
	Events.emit_signal("dungeon_entered")

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
		$map/place.show()




func _on_Area_body_entered(body):
	if body.is_in_group("hero"):
		Events.emit_signal("hero_finished")
