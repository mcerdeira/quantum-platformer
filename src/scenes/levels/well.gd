extends TileMap
var ttl = 2
var speed = 100
var played = false

func _physics_process(delta):
	ttl -= 1 * delta
	if ttl <= 0:
		if !played:
			played = true
			await get_tree().create_timer(1.5).timeout
			Global.play_sound(Global.FallInWellSFX)
			
		Global.player_obj.position.y += speed * delta
		speed += 100 * delta
