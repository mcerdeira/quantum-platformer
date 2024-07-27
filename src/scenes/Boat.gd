extends AnimatableBody2D
var move = false
var up = false

func _physics_process(delta):

	if move:
		position.x += 300 * delta 
	else:
		if up:
			position.y += 10 * delta
		else:	
			position.y -= 10 * delta
	
func _on_timer_timeout():
	move = !move

func _on_detector_body_entered(body):
	if body and body.is_in_group("players"):
		$Timer.start()

func _on_timer_2_timeout():
	if !move:
		up = !up
