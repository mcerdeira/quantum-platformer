extends Area2D

func _on_body_entered(body):
	if body and (body.is_in_group("enemies") or body.is_in_group("players") or body.is_in_group("interactuable")):
		if Global.TerminalNumber == Global.TerminalsEnum.LEAF:
			Global.play_sound(Global.LavaFallSFX, {}, body.global_position)
			Global.emit(body.global_position, 5)
		elif Global.TerminalNumber == Global.TerminalsEnum.TOMB:
			Global.play_sound(Global.FallInWellSFX, {}, body.global_position)
		body.kill_fall()

func _on_area_entered(area):
	if Global.TerminalNumber == Global.TerminalsEnum.LEAF:
		if area and area.is_in_group("bloods"):
			Global.emit(area.global_position, 1)
			area.queue_free()
