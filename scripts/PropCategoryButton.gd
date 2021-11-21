extends Button

onready var shortcut_backup: ShortCut = shortcut

export(int) var prop_category := 1

func _pressed():
	Events.emit_signal("prop_category_selected", prop_category)

func _ready():
	Events.connect("prop_placed", self, "set_pressed", [false])
	Events.connect("dungeon_entered", self, "on_dungeon_entered")
	Events.connect("prop_category_selected", self, "_on_prop_category_selected")
	shortcut_in_tooltip = false

func _on_prop_category_selected(cat: int):
	disabled = cat == prop_category
	shortcut = null if cat != 0 else shortcut_backup

func on_dungeon_entered():
	"""
	Reset HUD when entering dungeon
	"""
	Events.emit_signal("prop_category_selected", 0)
	Events.emit_signal("prop_selected", null)
	pressed = false
