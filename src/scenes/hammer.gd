extends Sprite2D

func _on_area_body_entered(body):
	if visible and body and body.is_in_group("players"):
		Global.play_sound(Global.InteractSFX)
		body.get_hammer()
		visible = false
		queue_free()
