extends RayCast2D
var cast_point = target_position

func _physics_process(delta):
	force_raycast_update()
	if is_colliding():
		cast_point = to_local(get_collision_point())
	else:
		cast_point = target_position
		
	var c = get_collider()
	if c and c.is_in_group("players"):
		c.kill_fire(0.3)
