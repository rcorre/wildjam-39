extends Area

func attack():
	for b in get_overlapping_bodies():
		b.propagate_call("hurt")
