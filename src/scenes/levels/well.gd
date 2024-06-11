extends TileMap
var ttl = 2
var speed = 100

func _physics_process(delta):
	ttl -= 1 * delta
	if ttl <= 0:
		Global.player_obj.position.y += speed * delta
		speed += 100 * delta
