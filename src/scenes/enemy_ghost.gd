extends CharacterBody2D
var total_speed = 50.0
var speed = total_speed
var jump_speed = -300.0
@export var direction = "right"
var total_friction = 0.6
var friction = total_friction
var moving = false
var buff = 0
var in_air = false
var idle_time = 0
var tspeed = 370.0
var initial_rotation = 0
var total_killing = 6
var killing = 0
var direction_change_ttl_total = 1
var direction_change_ttl = direction_change_ttl_total
var blowed = 0
var previus_velocity = Vector2.ZERO
var fire_obj = null
var level_parent = null
var fires = preload("res://scenes/Fires.tscn")
var dead = false
var delay = 4

func _ready():
	add_to_group("enemies")
	$sprite.animation = "idle"
	
func is_on_floor_custom():
	return is_on_floor() or buff > 0
	
func _physics_process(delta):
	delay -= 1 * delta 
	if delay <= 0:
		speed = total_speed * Global.time_speed
		if is_on_floor():
			if in_air:
				in_air = false
				Global.emit(global_position, 1)
			buff = 0.2
		else:
			in_air = true
			buff -= 1 * delta
			
		if fire_obj and is_instance_valid(fire_obj):
			fire_obj.reparent(level_parent)
			fire_obj.global_position = global_position
			fire_obj.z_index = z_index + 1
		
		if blowed > 0:
			blowed -= 1 * delta
			if is_on_wall():
				velocity.x = (previus_velocity.x / 2) * -1
			else:
				previus_velocity = velocity
		else:
			$stars_stunned.visible = false
			if !is_on_floor_custom():
				velocity.x = lerp(velocity.x, 0.0, friction / 10)
			else:
				velocity.x = lerp(velocity.x, 0.0, friction)

		process_player(delta)
		move_and_slide()
	else:
		velocity.y = -25
		move_and_slide()
	
func process_player(delta):
	var moving = true
	if $sprite.animation != "killing":
		$AnimationPlayer.play("killing")
	
	if blowed > 0:
		$stars_stunned.visible = true
		$sprite.animation = "stunned"
		return
		
	if Global.GAMEOVER:
		pass
		
	if dead:
		$sprite/eyes.animation = $sprite.animation
		$sprite/eyes.flip_h = $sprite.flip_h 
		$AnimationPlayer.stop()
		$stars_stunned.visible = false
		return
		
				
	if killing > 0:
		killing -= 1 * delta 
		if $sprite.animation != "killing":
			$AnimationPlayer.play("killing")
			$sprite.animation = "killing"
			$sprite/eyes.animation = "killing"
			$sprite.play()
		
		if killing <= 0:
			$AnimationPlayer.stop()
			$sprite.animation = "idle"
			killing = 0
	else:
		var direction = global_position.direction_to(Global.player_obj.global_position)
		velocity = direction * speed
		
		if global_position.x > Global.player_obj.global_position.x:
			direction = "left"
			$sprite.flip_h = true
		else:
			direction = "right"
			$sprite.flip_h = false
	
	if killing <= 0:
		if moving:
			if $sprite.animation == "idle":
				$sprite.animation = "walking"
			$sprite.play()
		else:
			$sprite.stop()
			idle_time += 1 * delta
			if idle_time >= 0.3:  
				$sprite.animation = "idle"
		
		$sprite/eyes.animation = $sprite.animation
		$sprite/eyes.flip_h = $sprite.flip_h 

func jump(delta):
	pass

func _on_area_body_entered(body):
	if !dead:
		if body and body.is_in_group("players"):
			body.kill()
			killing = total_killing
			if global_position.x > body.global_position.x:
				$sprite.flip_h = true
			else:
				$sprite.flip_h = false

func kill_fire():
	if fire_obj == null or !is_instance_valid(fire_obj):
		Global.emit(global_position, 10)	
		var parent = level_parent
		var p = fires.instantiate()
		parent.add_child(p)
		p.global_position = global_position
		p.kill_me = self
		fire_obj = p

func dead_fire():
	pass
	
func hearing_alerted(body):
	pass
	
func eat_gizmo(current_item):
	killing = total_killing
	
func kill_fall():
	visible = false
	queue_free()

func flyaway(direction):
	if blowed <= 0:
		blowed = 6.2
		Global.emit(global_position, 2)
		velocity = Global.flyaway(direction, jump_speed)
		previus_velocity = velocity

func super_jump():
	pass
