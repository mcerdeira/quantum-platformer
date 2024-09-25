extends Area2D

func _on_body_entered(body):
	if body and body.is_in_group("players"):
		Global.play_sound(Global.InteractSFX)
		Global.get_item(Global.spikeball)
		get_parent().queue_free()
