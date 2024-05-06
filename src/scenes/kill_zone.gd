extends Area2D

func _on_body_entered(body):
	if body and body.is_in_group("players"):
		body.queue_free()
		Global.main_camera.unregister_target(body)
