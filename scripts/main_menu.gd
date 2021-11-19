extends Control

var DungeonMasterScene = load("res://scenes/DungeonMasterScene.tscn")

func _on_Sandbox_pressed():
	Settings.is_sandbox = true
	start_game()

func _on_Play_pressed():
	Settings.is_sandbox = false
	start_game()

func start_game():
	print("Starting game")
	var game = DungeonMasterScene.instance()
	get_tree().root.add_child(game)
	queue_free()


func _on_quit_pressed():
	get_tree().quit()
