extends  Line2D
var gravity = 1000.0

func update_trayectory(direction, delta):
	var char = $GizmoFake
	var max_points = 500
	var velocity = direction
	var pos : Vector2 = Vector2.ZERO
	clear_points()
	for i in max_points:
		add_point(pos)
		velocity.y += gravity * delta
		var collision = char.move_and_collide(velocity * delta, false, true, true)
		if collision: 
			velocity = velocity.bounce(collision.get_normal()) * 0.2 
		
		pos += velocity * delta
		char.position = pos
