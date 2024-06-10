extends Area2D
var active = false
const FireBallHolderShoot = preload("res://scenes/FireBallHolderShoot.tscn")
var ttl_total = 9
var ttl = 0
var num_bullets = 50
var target = null

func _physics_process(delta):
	if active:
		if global_position.x > target.global_position.x:
			scale.x = -1
		else:
			scale.x = 1
			
		ttl -= 1 * delta
		if ttl <= 0:
			ttl = ttl_total
			for i in range(num_bullets):
				var p = FireBallHolderShoot.instantiate()
				var parent = get_parent()
				parent.add_child(p)
				p.global_position = $shoot_pos.global_position
				p.direction = Vector2.RIGHT.rotated(360 * i)
				Global.emit($shoot_pos.global_position, 5)

func _on_body_entered(body):
	if body and body.is_in_group("players") and !body.is_in_group("prisoners"):
		target = body
		if $sprite_eyes.animation != "awake":
			$sprite_eyes.animation = "awake"
			$sprite_eyes.play()
		
func _on_sprite_eyes_animation_finished():
	if $sprite_eyes.animation == "awake":
		$sprite_eyes.animation = "shoot"
		active = true
