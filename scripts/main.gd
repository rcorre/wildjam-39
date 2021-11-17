extends Spatial

onready var dungeonMaster = $DungeonMasterHUD
onready var player = preload("res://scenes/player.tscn").instance()

func _on_player_controler_toggled(player_control):
	if player_control:
		Events.emit_signal("dungeon_entered")
		remove_child(dungeonMaster)
		add_child(player)
	else:
		remove_child(player)
		add_child(dungeonMaster)
