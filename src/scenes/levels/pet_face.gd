extends Node2D

func _ready() -> void:
	if Global.CurrentState != Global.GameStates.PRE_ENDING:
		queue_free()
	else:
		await get_tree().create_timer(8.0).timeout
		Global.player_obj.show_message_custom("...", 2.0)
		await get_tree().create_timer(3.0).timeout
		Global.player_obj.show_message_custom("¿Donde se metio mi amo?", 2.0)
		await get_tree().create_timer(3.0).timeout
		Global.player_obj.show_message_custom("...", 2.0)
		await get_tree().create_timer(3.0).timeout
		Global.player_obj.show_message_custom("¡Supongo que toca ir a buscarlo!", 2.0)
		await get_tree().create_timer(3.0).timeout
