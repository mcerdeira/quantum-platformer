extends Area2D
var closed = true
@export var Doors : Array[StaticBody2D]

func _process(delta):
	var overlapping_bodies = get_overlapping_bodies()
	for body in overlapping_bodies:
		if (body.is_in_group("enemies") or body.is_in_group("players") or body.is_in_group("interactuable")):
			open()
			return
	
	close()

func open():
	if closed:
		closed = false
		$AnimatedSprite2D.frame = 1
		for door in Doors:
			door.open()

func close():
	if !closed:
		closed = true
		$AnimatedSprite2D.frame = 0
		for door in Doors:
			door.close()
