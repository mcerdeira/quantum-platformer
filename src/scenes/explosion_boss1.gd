extends Area2D
var parent = null
var size = Vector2(200, 200)
var new_tile_id = 2
var radius =  null
var center = null

func _ready():
	parent = get_parent() 
	radius = 295.2

func _process(_delta):
	var overlapping_bodies = get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.is_in_group("gizmos"):
			get_parent().flyaway()
			var direction = (body.global_position-parent.global_position).normalized()
			body.flyaway(direction * 5) 
			
		if body != parent and (body.is_in_group("enemies") or body.is_in_group("players") or body.is_in_group("interactuable")):
			var direction = (body.global_position-parent.global_position).normalized()
			if parent.blowed <= 0:
				body.flyaway(direction * 5) 
			else:
				if body.is_in_group("players"):
					body.miniflyaway(direction * 5) 
				else:
					body.flyaway(direction * 10) 
