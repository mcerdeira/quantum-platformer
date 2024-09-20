extends Area2D

func _on_body_entered(body):
	if body and (body.is_in_group("enemies") or body.is_in_group("players") or body.is_in_group("interactuable")):
		Global.play_sound(Global.LavaFallSFX, {}, body.global_position)
		Global.emit(body.global_position, 5)
		body.kill_fall()
