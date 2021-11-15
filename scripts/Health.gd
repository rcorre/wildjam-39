extends Area


func _ready():
	connect("area_entered", self, "on_health_area_entered")
	
func on_health_area_entered(area : Area):
	print("Got hit by ", area)
