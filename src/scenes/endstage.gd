extends Area2D
var actived = false

func _on_body_entered(body: Node2D) -> void:
	if $"../path_persecution/pet_follower/pet_persecution".following:
		if !actived and body and body.is_in_group("players"):
			body.face_override("scared")
			body.idle_time = -10
			body.locked_ctrls = true
			body.velocity.x = 0
			body.lookright()
			actived = true
