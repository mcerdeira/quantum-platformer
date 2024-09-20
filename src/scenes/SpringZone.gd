extends Area2D
var parent = null

func _ready():
	parent = get_parent() 

func _physics_process(delta):
	if parent.is_active:
		var overlapping_bodies = get_overlapping_bodies()
		for body in overlapping_bodies:
			if body != parent and (body.is_in_group("enemies") or body.is_in_group("players") or body.is_in_group("interactuable")):
				Global.play_sound(Global.SpringSFX)
				parent.activate()
				body.super_jump()
