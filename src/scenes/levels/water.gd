extends Area2D

func _on_body_entered(body):
	if Global.TerminalNumber != Global.TerminalsEnum.MERMAID:
		if body.is_in_group("players"):
			if !Global.player_obj.locked_ctrls:
				body.reset_to_last()
