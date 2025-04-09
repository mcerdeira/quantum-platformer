extends Sprite2D

func _on_area_area_entered(area: Area2D) -> void:
	if visible and area and area.is_in_group("players"):
		Global.play_sound(Global.InteractSFX)
		area.get_gun()
		visible = false
		queue_free()
