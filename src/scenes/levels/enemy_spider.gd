extends Area2D
var speedup = 200.0
var speedupfinal = 300.0
var speeddown = 55.0
var speed = speeddown
var swing_dir = 1
var going_down = 1
var floor_collide = false
var killing = false
var started = 0
var start_position = Vector2.ZERO
@export var Web : Line2D
@export var Stair : Area2D

func _ready() -> void:
	start_position = position
	started = randi() % 10

func _physics_process(delta: float) -> void:
	if started > 0:
		started -= 1 * delta
	if started <= 0:
		if !killing:
			if position.x >= 5 and swing_dir == 1:
				swing_dir = -1
				
			if position.x <= -5 and swing_dir == -1:
				swing_dir = 1
				
			if (position.y > start_position.y * 16 or floor_collide) and going_down == 1:
				floor_collide = false
				going_down *= -1
				speed = speedup
				started = Global.pick_random([5.1, 6.1, 3.1])
				
			if position.y <= start_position.y and going_down == -1:
				speed = speeddown
				going_down *= -1
				started = 1.1
				
			if going_down == -1:
				speed = lerp(speed, speedupfinal, 0.1)
				
			position.x += (5.0 * swing_dir) * delta
			position.y += (speed * going_down) * delta
			Stair.scale.y = position.y / 33
			
			Web.set_point_position(1, Vector2(position.x, position.y))
		else:
			position.x = lerp(position.x, 0.0, 0.1)
			Web.set_point_position(1, Vector2(position.x, position.y))
	else:
		position.x = lerp(position.x, 0.0, 0.1)
		Web.set_point_position(1, Vector2(position.x, position.y))

func _on_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		Global.play_sound(Global.EnemyChewingSFX, {}, global_position)
		body.kill()
		killing = true
		$AnimationPlayer.play("killing")
		if global_position.x > body.global_position.x:
			$sprite.flip_h = true
		else:
			$sprite.flip_h = false


func _on_floor_notify_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is TileMap:
		floor_collide = true
