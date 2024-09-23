extends CharacterBody2D
var gravity = 1000.0
var jump_speed = -300.0
var total_friction = 0.6
var friction = total_friction
var landed = false
var ttl = 0.5
var blowed = 0
var count_down = 0
var broken = false
var master_parent = null

func _ready():
	add_to_group("fireballholder")
	add_to_group("interactuable")
	
func is_on_floor_custom(normal):
	return (normal == Vector2.UP)
		
func _physics_process(delta):
	if broken:
		velocity = Vector2.ZERO
	else:
		velocity.y += gravity * delta
		var collision = move_and_collide(velocity * delta)
		if collision: 
			var normal = collision.get_normal()
			velocity = velocity.bounce(normal) * Global.bounce_amount
			if is_on_floor_custom(normal):
				if !landed and !broken:
					Global.emit(global_position, 10)
					got_broken()
		
				landed = true 

				if blowed > 0:
					blowed -= 1 * delta
				else:
					pass
					if !is_on_floor():
						velocity.x = lerp(velocity.x, 0.0, friction / 10)
					else:
						velocity.x = lerp(velocity.x, 0.0, friction)
					
func got_broken():
	var options = {"pitch_scale": Global.pick_random([1, 1.1, 1.2])}
	Global.play_sound(Global.BrokenLampSFX, options, global_position)
	await get_tree().create_timer(1).timeout
	$Lamp.animation = "broken"
	$Lamp/sprite.visible = false
	Global.emit(global_position, 10)
	$collider.set_deferred("disabled", true)
	$FireBall.queue_free()
	broken = true

func flyaway(direction):
	if blowed <= 0:
		blowed = 2
		Global.emit(global_position, 2)
		velocity = Global.flyaway(direction, jump_speed)

func kill_fall():
	visible = false
	queue_free()

func super_jump():
	Global.emit(global_position, 2)
	velocity.y = jump_speed * 2
