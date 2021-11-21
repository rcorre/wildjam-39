extends Control

var DungeonMasterScene = load("res://scenes/DungeonMasterScene.tscn")
var button_hover = load("res://audio/sfx/menu/button_hover.wav")
var button_select = load("res://audio/sfx/menu/button_select.wav")

func _on_Play_pressed():
	$sfx.stream = button_select
	$sfx.play()
	start_game()

func start_game():
	var game = DungeonMasterScene.instance()
	game.connect("tree_entered", get_tree(), "set_current_scene", [game], CONNECT_ONESHOT)
	get_tree().root.add_child(game)
	queue_free()
	print("started")
	Events.emit_signal("game_started")

func _on_quit_pressed():
	get_tree().quit()

func _on_btn_mouse_entered():
	$sfx.stream = button_hover
	$sfx.play()
