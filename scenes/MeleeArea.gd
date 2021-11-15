extends Area

func _on_MeleeArea_body_entered(body):
	body.propagate_call("hurt")
