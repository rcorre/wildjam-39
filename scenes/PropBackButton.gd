extends Button

func _pressed():
	Events.emit_signal("prop_category_selected", 0)
