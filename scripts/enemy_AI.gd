extends Spatial

signal look_towards(position)
signal move_towards(move_dir)
var target

func _ready():
	target = get_tree().get_nodes_in_group("player")[0]
	
func _physics_process(delta):
	#nav mesh -> end goal
	emit_signal("look_towards", target.translation)
