extends CharacterBody2D
var gravity = 0.5
var total_speed = 60.0
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
var spr_sufix = ""

func _ready():
	add_to_group("enemies")
	$sprite.animation = "idle" + spr_sufix
	
func is_on_floor_custom():
	return is_on_floor() or buff > 0
	
func _physics_process(delta):
	speed = total_speed
	if is_on_floor():
		if in_air:
			$AnimationWings.stop()
			in_air = false
			Global.emit(global_position, 1)
		buff = 0.2
	else:
		if !in_air:
			$AnimationWings.play("new_animation")
		in_air = true
		buff -= 1 * delta
		
	if fire_obj and is_instance_valid(fire_obj):
		fire_obj.reparent(level_parent)
		fire_obj.global_position = global_position
		fire_obj.z_index = z_index + 1
	
	if !is_on_floor_custom():
		velocity.y += gravity
	
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
	
func process_player(delta):
	var moving = false
	if blowed > 0:
		$stars_stunned.visible = true
		$sprite.animation = "stunned" + spr_sufix
		return
		
	if Global.GAMEOVER:
		pass
		
	if dead:
		$sprite/eyes.animation = $sprite.animation.replace(spr_sufix, "")
		$sprite/eyes.flip_h = $sprite.flip_h 
		$sprite/Nose.flip_h = $sprite.flip_h 
		$AnimationPlayer.stop()
		$stars_stunned.visible = false
		return
		
				
	if killing > 0:
		killing -= 1 * delta 
		if $sprite.animation != "killing" + spr_sufix:
			$AnimationPlayer.play("killing" + spr_sufix)
			$sprite.animation = "killing" + spr_sufix
			$sprite/eyes.animation = "killing" + spr_sufix
			$sprite.play()
			$sprite/Nose.play()
			$sprite/eyes.play()
		
		if killing <= 0:
			$AnimationPlayer.stop()
			$sprite.animation = "idle" + spr_sufix
			killing = 0
	else:
	
		if direction == "right":
			moving = true
			idle_time = 0
			velocity.x = speed
			$sprite.flip_h = false
		else:
			moving = true
			idle_time = 0
			velocity.x = -speed
			$sprite.flip_h = true
		
		if direction_change_ttl > 0: 
			direction_change_ttl -= 1 * delta
		
		if is_on_wall():
			if direction_change_ttl <= 0:
				direction_change_ttl = direction_change_ttl_total
				if direction == "right":
					direction = "left"
					$sprite.flip_h = true
					move_child($wing1, 0)
					move_child($wing2, 6)
				else:
					direction = "right"
					$sprite.flip_h = false
					move_child($wing1, 6)
					move_child($wing2, 0)
	
	if killing <= 0:
		if moving:
			if $sprite.animation == "idle" + spr_sufix:
				$sprite.animation = "walking" + spr_sufix
			$sprite.play()
			$sprite/Nose.play()
			$sprite/eyes.play()
		else:
			$sprite.stop()
			$sprite/eyes.stop()
			$sprite/Nose.stop()
			idle_time += 1 * delta
			if idle_time >= 0.3:  
				$sprite.animation = "idle" + spr_sufix
		
		$sprite/eyes.animation = $sprite.animation.replace(spr_sufix, "")
		$sprite/eyes.flip_h = $sprite.flip_h 
		$sprite/Nose.flip_h = $sprite.flip_h 

func jump(delta):
	if !Global.GAMEOVER:
		if is_on_floor_custom():
			buff = 0
			Global.play_sound(Global.EnemyJumpSFX, {}, global_position)
			Global.emit(global_position, 2)
			velocity.y = jump_speed

func _on_area_body_entered(body):
	if !dead and blowed <= 0:
		if body and body.is_in_group("players"):
			Global.play_sound(Global.EnemyChewingSFX, {}, global_position)
			body.kill()
			killing = total_killing
			if global_position.x > body.global_position.x:
				$sprite.flip_h = true
			else:
				$sprite.flip_h = false

func kill_fire():
	if fire_obj == null or !is_instance_valid(fire_obj):
		if level_parent:
			Global.emit(global_position, 10)	
			var parent = level_parent
			var p = fires.instantiate()
			p.global_position = global_position
			p.kill_me = self
			parent.add_child(p)
			fire_obj = p

func dead_fire():
	dead = true
	$sprite.animation = "dead_fire" + spr_sufix
	$sprite.play()
	set_collision_layer_value(5, true)
	set_collision_mask_value(5, true)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
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
	Global.emit(global_position, 2)
	velocity.y = jump_speed * 2
