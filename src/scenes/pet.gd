extends Node2D
var active = false
var speed = 518
var ttl = 6.7
var msgs = ["¡¡PEPITO!!", "¿DONDE VAS?", "¡NO! ¡VOLVE!"]

func _ready() -> void:
	if Global.AlreadySEEN:
		queue_free()

func _physics_process(delta: float) -> void:
	if active:
		position.x += (speed * scale.x) * delta
		ttl -= 1 * delta
		speed += 10
		if ttl <= 0:
			queue_free()

func _on_area_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		active = true
		body.show_message_custom(Global.pick_random(msgs), 2.1)
		$AnimationPlayer.play("new_animation")
