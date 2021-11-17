extends TabContainer

func _ready():
	Events.connect("prop_category_selected", self, "set_current_tab")

func _unhandled_input(ev: InputEvent):
	if ev.is_action_pressed("ui_cancel"):
		Events.emit_signal("prop_category_selected", 0)
		Events.emit_signal("prop_selected", null)
