extends HBoxContainer

func _ready():
	var group := ButtonGroup.new()
	for i in range(get_child_count()):
		var b := get_child(i) as Button
		if not b:
			continue
		b.set_button_group(group)
		b.shortcut = ShortCut.new()
		b.shortcut.shortcut = InputEventAction.new()
		b.shortcut.shortcut.action = "prop%d" % (i + 1)
