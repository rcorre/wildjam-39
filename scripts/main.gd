extends Spatial

onready var dungeonMaster = $DungeonMasterHUD
onready var player = preload("res://scenes/player.tscn").instance()
onready var ai = preload("res://scenes/Hero.tscn").instance()
var main_menu = load("res://scenes/main_menu.tscn").instance()

func _ready():
	Events.connect("hero_died", self, "on_hero_died")

func on_hero_died():
	#TODO: go to next phase of game. Triggred on AI death and player
	pass

func _on_player_controler_toggled(player_control):
	if player_control:
		Events.emit_signal("dungeon_entered")
		$ai_button.hide()
		remove_child(dungeonMaster)
		add_child(player)
	else:
		remove_child(player)
		$ai_button.show()
		add_child(dungeonMaster)

func _on_ai_toggled(on: bool):
	if on:
		Events.emit_signal("dungeon_entered")
		remove_child(dungeonMaster)
		$player_controler.hide()
		add_child(ai)
	else:
		remove_child(ai)
		$player_controler.show()
		add_child(dungeonMaster)
		


func _on_pause_quit():
	get_tree().root.add_child(main_menu)
	queue_free()
