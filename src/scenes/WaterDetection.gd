extends Area2D

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if get_parent().jumping or get_parent().moving or (!get_parent().jumping and get_parent().in_air):
		if body_rid and !body:
			var ps = PhysicsServer2D 
			var current_velocity = Vector2.ZERO
			var valx = null
			if get_parent().moving:
				if get_parent().direction == "right":
					valx = randf_range(0.0, 0.7)
				else:
					valx = randf_range(0.0, 0.7) * -1
			else:
				valx = randf_range(0.0, 0.7) * Global.pick_random([-1, 1])
			
			var valy = randf_range(0.2, 0.5)
			ps.body_apply_impulse(body_rid, current_velocity + Vector2(valx, -valy))
