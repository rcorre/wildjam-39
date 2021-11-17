extends Area


export(StreamTexture) var icon

signal interact(player_interactable)

func _ready():
	# don't block the mouse during placement
	input_ray_pickable = false
