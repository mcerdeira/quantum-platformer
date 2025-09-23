extends Area2D
@export var coin_exploder = false
var delay = 0.0

func _ready() -> void:
	if coin_exploder:
		delay = 0.1
		
func _physics_process(delta: float) -> void:
	if delay > 0:
		delay -= 1 * delta

func _on_body_entered(body):
	if visible:
		if delay <= 0:
			if body and body.is_in_group("players"):
				Global.play_sound(Global.CoinSFX)
				visible = false
				Global.get_item(Global.coin, 1)
				if coin_exploder:
					get_parent().queue_free()
				queue_free()
