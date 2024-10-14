extends Area2D
@export var fixed = false

func _ready():
	if !fixed:
		if randi() % 2 == 0: 
			queue_free()

func _on_body_entered(body):
	if body and body.is_in_group("players"):
		Global.play_sound(Global.PlayerSpikedSFX)
		body.kill()
		$sprite.animation = "blood"
