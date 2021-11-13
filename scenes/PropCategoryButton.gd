extends Button

export(int) var prop_category := 1

func _pressed():
	Events.emit_signal("prop_category_selected", prop_category)

func _ready():
	Events.connect("prop_placed", self, "set_pressed", [false])
	Events.connect("prop_category_selected", self, "_on_prop_category_selected")

func _on_prop_category_selected(cat: int):
	disabled = cat != 0
