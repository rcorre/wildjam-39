extends Area


export(StreamTexture) var icon

signal interact()

func _ready():
	# don't block the mouse during placement
	input_ray_pickable = false
