extends Area2D
var parent = null
var size = Vector2(200, 200)
var new_tile_id = 2
var radius =  null
var center = null
@export var from_gizmo = false

func _ready():
	parent = get_parent() 
	radius = 295.2

func _process(_delta):
	if from_gizmo:
		var overlapping_areas = get_overlapping_areas()
		for area in overlapping_areas:
			if area != parent and area.is_in_group("enemy_bullet"):
				area.kill()
	
	var overlapping_bodies = get_overlapping_bodies()
	for body in overlapping_bodies:
		if body != parent and (body.is_in_group("enemies") or body.is_in_group("players") or body.is_in_group("interactuable")):
			var direction = (body.global_position-parent.global_position).normalized()
			body.flyaway(direction * 10) 

func _on_area_entered(area):
	if area and area.is_in_group("bicho_feo"):
		area.slow_down()
