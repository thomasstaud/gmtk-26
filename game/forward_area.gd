extends Area3D

@onready var player : Node3D = $".."

func has_normal_overlapping_bodies() -> bool:
	# get only walls and ignore player model stuff
	var reduced_bodies = self.get_overlapping_bodies()
	reduced_bodies.erase(player)
	
	if (!self.has_overlapping_bodies()):
		return false
	else:
		return len(reduced_bodies) > 0
