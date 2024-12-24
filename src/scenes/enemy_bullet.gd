extends Area2D
var active = false
const CoinExploder = preload("res://scenes/Coinexploder.tscn")
const FireBallHolderShoot = preload("res://scenes/FireBallHolderShoot.tscn")
var ttl_total = 9
var ttl = 0
var num_bullets = 60
var target = null
var dir = -1
var initial_position = null
var sleep_counter_total = 12
var sleep_counter = sleep_counter_total
var dead = false
var count_dead = 10
var count_kill = 0
var scalex_sign = 1

func _ready():
	add_to_group("enemy_bullet")
	initial_position = global_position
	
func kill():
	if !dead:
		drop_coins()
		$explosions.start()
		$Timer.start()
		dead = true
		$sprite_eyes.animation = "dead"
		
func drop_coins():
	Global.play_sound(Global.CoinSFX)
	var coins = Global.pick_random([25, 15, 35])
	for i in range(coins):
		var p = CoinExploder.instantiate()
		var parent = get_parent()
		p.global_position = $shoot_pos.global_position
		parent.add_child(p)
		
func hover(delta):
	if round(initial_position.y + 8 * dir) == round(global_position.y):
		dir *= -1
	global_position.y += (20 * dir) * delta 

func _physics_process(delta):
	if dead:
		if count_dead <= 0:
			global_position.y += 45 * delta
			if count_kill >= 150:
				queue_free()
		else:
			hover(delta)
	else:
		hover(delta)
			
		if active:
			if global_position.distance_to(target.global_position) >= 500:
				sleep_counter -= 1 * delta 
				if sleep_counter <= 0:
					sleep()
					return
			
			if global_position.x > target.global_position.x:
				scale.x = -1
				scalex_sign = -1
			else:
				scale.x = 1
				scalex_sign = 1
				
			ttl -= 1 * delta
			if ttl <= 0:
				ttl = ttl_total
				for i in range(num_bullets):
					var p = FireBallHolderShoot.instantiate()
					var parent = get_parent()
					p.global_position = $shoot_pos.global_position
					p.direction = Vector2.RIGHT.rotated(360 * i)
					parent.add_child(p)
					Global.emit($shoot_pos.global_position, 5)

func _on_body_entered(body):
	if !dead:
		if body and body.is_in_group("players") and !body.is_in_group("prisoners"):
			target = body
			if $sprite_eyes.animation != "awake":
				$sprite_eyes.animation = "awake"
				$sprite_eyes.play()
		
func _on_sprite_eyes_animation_finished():
	if !dead:
		if $sprite_eyes.animation == "awake":
			$sprite_eyes.animation = "shoot"
			active = true

func sleep():
	if !dead:
		active = false
		ttl = 0
		$sprite_eyes.animation = "sleeping"
		sleep_counter = sleep_counter_total

func _on_timer_timeout():
	if count_dead > 0:
		count_dead -= 1
	else:
		count_kill += 1
			
	var chances = [1, 0.7, 0.5, 1.1, 1.3]
	$sprite.scale.y = (Global.pick_random(chances))
	$sprite.scale.x = (Global.pick_random(chances)) * scalex_sign
	$sprite_eyes.scale = $sprite.scale
