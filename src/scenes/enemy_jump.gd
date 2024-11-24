extends Area2D
var ttl = 0

func _physics_process(delta):
	if ttl > 0:
		ttl -= 1 * delta
		
	if ttl <= 0:
		if !get_parent().dead:
			var overlapping_bodies = get_overlapping_bodies()
			for body in overlapping_bodies:
				if body.is_in_group("players"):
					if body.is_in_group("players") and body.is_on_stairs and body.grabbed:
						return
					Global.play_sound(Global.GizmoDropSFX)
					get_parent().velocity = Vector2.ZERO
					get_parent().blowed = 2.5
					var options = {"pitch_scale": 1.5}
					Global.play_sound(Global.JumpSFX, options)
					ttl = 1
					body.jump_forced()
