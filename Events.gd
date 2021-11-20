extends Node

# Global event bus
# warning-ignore-all: UNUSED_SIGNAL

signal prop_category_selected(cat)
signal prop_selected(scene)
signal prop_placed()
signal dungeon_entered()
signal hero_died()
signal pause_pressed()

var can_pause = false

func _unhandled_input(event):
	if Input.is_action_just_pressed("pause") and can_pause:
		emit_signal("pause_pressed")
		get_tree().paused = !get_tree().paused
