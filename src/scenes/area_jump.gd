extends Area2D

func _physics_process(delta):
	var overlapping_bodies = get_overlapping_bodies()
	for body in overlapping_bodies:
		if (body.is_in_group("enemies") or body.is_in_group("players") or body.is_in_group("interactuable")):
			if body.is_in_group("players") and body.is_on_stairs and body.grabbed:
				return
			Global.play_sound(Global.SpringSFX)
			body.super_jump()
			$"../AnimationPlayer2".play("new_animation")