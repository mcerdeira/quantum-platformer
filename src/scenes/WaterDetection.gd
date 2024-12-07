extends Area2D

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if get_parent().jumping:
		if body_rid and !body:
			var ps = PhysicsServer2D 
			var current_velocity = Vector2.ZERO
			var valx = randf_range(0.0, 0.7) *  Global.pick_random([-1, 1])
			var valy = randf_range(0.7, 1.2)
			ps.body_apply_impulse(body_rid, current_velocity + Vector2(valx, -valy))
