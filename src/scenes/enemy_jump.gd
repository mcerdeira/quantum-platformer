extends Area2D

func _physics_process(delta):
	if !get_parent().dead:
		var overlapping_bodies = get_overlapping_bodies()
		for body in overlapping_bodies:
			if body.is_in_group("players"):
				if body.is_in_group("players") and body.is_on_stairs and body.grabbed:
					return
				Global.play_sound(Global.GizmoDropSFX)
				get_parent().velocity = Vector2.ZERO
				get_parent().blowed = 2.5
				body.jump_forced()
