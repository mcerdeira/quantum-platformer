extends Area2D

func _on_body_entered(body):
	if body and body.is_in_group("players"):
		body.kill()
		$sprite.animation = "blood"
