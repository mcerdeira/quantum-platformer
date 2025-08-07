extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		body.face_override("scared")
		body.idle_time = -100000000000
		body.locked_ctrls = true
		body.velocity.x = 0
		body.lookright()
		
		await get_tree().create_timer(3.0).timeout
		Global.player_obj.show_message_custom("...", 2.0)
		await get_tree().create_timer(3.0).timeout
		Global.player_obj.show_message_custom("Al final... luego de todo lo vivido...", 2.0)
		await get_tree().create_timer(2.0).timeout
		Global.player_obj.show_message_custom("...", 2.0)
		await get_tree().create_timer(2.0).timeout
		Global.player_obj.show_message_custom("y todo lo que ha pasado...", 2.0)
		await get_tree().create_timer(2.0).timeout
		Global.player_obj.show_message_custom("...", 2.0)
		await get_tree().create_timer(2.0).timeout
		Global.player_obj.show_message_custom("supongo que valio la pena...", 2.0)
		await get_tree().create_timer(2.0).timeout
		Global.player_obj.show_message_custom("...", 2.0)
		await get_tree().create_timer(2.0).timeout
		Global.player_obj.show_message_custom("pasar por todo esto... por vos...", 2.0)
		await get_tree().create_timer(2.0).timeout
		Global.player_obj.show_message_custom("...", 2.0)
		await get_tree().create_timer(2.0).timeout
		Global.player_obj.show_message_custom("Te voy a extrañar...", 2.0)
		await get_tree().create_timer(2.0).timeout
		Global.player_obj.show_message_custom("...", 2.0)
		await get_tree().create_timer(2.0).timeout
		Global.player_obj.show_message_custom("Pepito...", 3.5)
		await get_tree().create_timer(3.5).timeout
		Global.CurrentState = Global.GameStates.PRE_ENDING
		Global.scene_next()
