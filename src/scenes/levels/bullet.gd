extends CharacterBody2D
var gravity = 1000.0
var total_friction = 0.6
var friction = total_friction
var shoted = false
var _explode = false 
var ttl = 0.1
var gameman = null
var tank = null

func _physics_process(delta):
	if shoted and !_explode:
		velocity.y += gravity * delta
		var collision = move_and_collide(velocity * delta)
		rotation = velocity.angle()
	elif shoted and _explode:
		ttl -= 1 * delta
		if ttl <= 0:
			gameman.player_turn = !gameman.player_turn
			if tank:
				tank.reboot()
			queue_free()
		
func droped(_direction):
	velocity = _direction
	shoted = true

func explode():
	velocity = Vector2.ZERO
	_explode = true
	visible = false
	ttl = 0.1
	$Area2D/colliderex.set_deferred("disabled", false)
	$Area2D/collider.set_deferred("disabled", true)

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var coords = body.get_coords_for_body_rid(body_rid)
		if body.get_cell_source_id(0, coords) == 1:#RETRO GAME
			body.set_cell(0, coords, -1, Vector2(0, 0))
			explode()

func _on_area_2d_body_entered(body):
	if body and body.is_in_group("tanks"):
		body.die()
		explode()
		$Area2D/collidermax.set_deferred("disabled", false)
