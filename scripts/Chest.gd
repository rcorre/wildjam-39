extends StaticBody



func _on_interactable_interact():
	print("I was used, give player item x")
	queue_free()
