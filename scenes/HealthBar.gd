extends HBoxContainer

var health := 3

func hurt():
	health -= 1
	for i in range(get_child_count()):
		var c: Control = get_child(i)
		c.modulate = Color.red if i < health else Color.gray
