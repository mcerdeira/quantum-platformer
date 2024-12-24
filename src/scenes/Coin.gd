extends Area2D
@export var coin_exploder = false

func _on_body_entered(body):
	if visible:
		if body and body.is_in_group("players"):
			Global.play_sound(Global.CoinSFX)
			visible = false
			Global.get_item(Global.coin, 1)
			if coin_exploder:
				get_parent().queue_free()
			queue_free()
