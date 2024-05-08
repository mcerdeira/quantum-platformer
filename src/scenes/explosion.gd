extends Area2D
var parent = null

func _ready():
	parent = get_parent() 

func _process(delta):
	var overlapping_bodies = get_overlapping_bodies()
	for body in overlapping_bodies:
		if body != parent and (body.is_in_group("enemies") or body.is_in_group("players") or body.is_in_group("interactuable")):
			var direction = (body.global_position-parent.global_position).normalized()
			body.flyaway(direction * 10) 
