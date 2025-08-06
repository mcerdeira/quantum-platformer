extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		Global.CurrentState = Global.GameStates.OVERWORLD_ENDING
		Global.scene_next()
