extends Area2D
var target = null
var fall_ttl = 6
var total_ttl = 1.5
var fade = null

func _process(delta):
	Global.GAMEOVER = false
	if target:
		if !fade:
			fade = get_node("../ColorRect")
		
		fade.color.a += 5 * delta
		target.modulate.a -= 2 * delta
		fall_ttl -= 1 * delta
		total_ttl -= 1 * delta
		if fall_ttl <= 0:
			target.velocity = Vector2.ZERO
			
		if total_ttl <= 0:
			Global.scene_next()
			
func _on_body_entered(body):
	if body.is_in_group("players"):
		target = body
