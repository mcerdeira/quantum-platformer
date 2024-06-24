extends Area2D
var active = false
const FireBallHolderShoot = preload("res://scenes/FireBallHolderShoot.tscn")
var ttl_total = 9
var ttl = 0
var num_bullets = 60
var target = null
var dir = -1
var initial_position = null
var sleep_counter_total = 12
var sleep_counter = sleep_counter_total

func _ready():
	initial_position = global_position

func _physics_process(delta):
	if round(initial_position.y + 8 * dir) == round(global_position.y):
		dir *= -1
	global_position.y += (20 * dir) * delta 
		
	if active:
		if global_position.distance_to(target.global_position) >= 500:
			sleep_counter -= 1 * delta 
			if sleep_counter <= 0:
				sleep()
				return
		
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
				p.global_position = $shoot_pos.global_position
				p.direction = Vector2.RIGHT.rotated(360 * i)
				parent.add_child(p)
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

func sleep():
	active = false
	ttl = 0
	$sprite_eyes.animation = "sleeping"
	sleep_counter = sleep_counter_total
