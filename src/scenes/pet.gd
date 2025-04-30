extends Node2D
var active = false
var speed = 518
var ttl = 6.7

func _physics_process(delta: float) -> void:
	if active:
		position.x += (speed * scale.x) * delta
		ttl -= 1 * delta
		if ttl <= 0:
			queue_free()

func _on_area_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		active = true
		$AnimationPlayer.play("new_animation")
