extends  Line2D
var gravity = 1000.0
@export var mark : Marker2D

func update_trayectory(direction, delta):
	var char_g = $GizmoFake
	var max_points = 600
	var velocity = direction
	var pos : Vector2 = Vector2.ZERO
	clear_points()
	for i in max_points:
		add_point(pos)
		velocity.y += gravity * delta
		var collision = char_g.move_and_collide(velocity * delta, false, true, true)
		if collision: 
			velocity = velocity.bounce(collision.get_normal()) * Global.bounce_amount 
			pos += velocity * delta
			char_g.position = pos
			break;
			
		pos += velocity * delta
		char_g.position = pos
