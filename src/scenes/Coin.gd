extends Area2D

func _ready():
	if randi() % 10 == 0:
		queue_free()

func _on_body_entered(body):
	if visible:
		if body and body.is_in_group("players"):
			Global.play_sound(Global.CoinSFX)
			visible = false
			Global.get_item(Global.coin, 1)
			queue_free()