extends Area2D
var actived = false

func _on_body_entered(body: Node2D) -> void:
	if !actived and body and body.is_in_group("players"):
		body.locked_ctrls = true
		body.velocity.x = 0
		body.direction = "right"
		actived = true
