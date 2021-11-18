extends Spatial

onready var dungeonMaster = $DungeonMasterHUD
onready var player = preload("res://scenes/player.tscn").instance()
onready var ai = preload("res://scenes/Hero.tscn").instance()

func _ready():
	Events.connect("hero_died", self, "on_hero_died")

func on_hero_died():
	#TODO: go to next phase of game. Triggred on AI death and player
	pass

func _on_player_controler_toggled(player_control):
	if player_control:
		Events.emit_signal("dungeon_entered")
		remove_child(dungeonMaster)
		add_child(player)
	else:
		remove_child(player)
		add_child(dungeonMaster)

func _on_ai_toggled(on: bool):
	if on:
		Events.emit_signal("dungeon_entered")
		remove_child(dungeonMaster)
		add_child(ai)
	else:
		remove_child(ai)
		add_child(dungeonMaster)
		
