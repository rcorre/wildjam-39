extends Area

func _on_MeleeArea_body_entered(body):
	#if type is skeleton do extra damage 
	body.propagate_call("hurt")
