extends Area2D

func _on_activator_body_entered(body: Node2D) -> void:
	if $"../boss".persecution:
		if !visible and body and body.is_in_group("players"):
			visible = true
			$"../boss".visible = false
