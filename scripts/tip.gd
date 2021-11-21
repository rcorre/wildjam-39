extends Label

func _ready():
	yield(get_tree().create_timer(10), "timeout")
	$AnimationPlayer.play("fade")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
