extends Area2D
var parent = get_parent()

func _ready():
	parent = get_parent() 

func _process(_delta):
	var overlapping_bodies = get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.is_in_group("gizmos"):
			var direction = (body.global_position-parent.global_position).normalized()
			body.flyaway(direction * 5) 

		if body != parent and body.is_in_group("players"):
			var direction = (body.global_position-parent.global_position).normalized()
			body.flyaway(direction * 5) 
