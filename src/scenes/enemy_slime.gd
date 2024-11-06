extends CharacterBody2D
var gravity = 10.0
var total_speed = 60.0
var speed = total_speed
var jump_speed = -300.0
@export var direction = "right"
var jumping = false
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
var attached = false

func _ready():
	add_to_group("enemies")
	$sprite.animation = "idle"
	
func is_on_floor_custom():
	return is_on_floor() or buff > 0
	
func _physics_process(delta):
	speed = total_speed
	if is_on_floor():
		if in_air:
			in_air = false
			Global.emit(global_position, 1)
		buff = 0.2
	else:
		in_air = true
		buff -= 1 * delta
		
	if fire_obj and is_instance_valid(fire_obj):
		var current = fire_obj.get_parent()
		if current:
			fire_obj.reparent(level_parent)
		else:
			level_parent.add_child(fire_obj)
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
	moving = false
	
	if blowed > 0:
		$stars_stunned.visible = true
		$sprite.animation = "stunned"
		return
		
	if Global.GAMEOVER:
		pass
		
	if dead:
		$stars_stunned.visible = false
		return

	else:
		if attached:
			velocity = Vector2.ZERO
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
				
			if jumping:
				if randi() % 5 == 0:
					jump()
			
			if is_on_wall():
				if direction_change_ttl <= 0:
					direction_change_ttl = direction_change_ttl_total
					if direction == "right":
						direction = "left"
						$sprite.flip_h = true
						$AreaDetect.scale.x = -1
					else:
						direction = "right"
						$sprite.flip_h = false
						$AreaDetect.scale.x = 1
		
			if killing <= 0:
				if moving:
					if $sprite.animation != "walking":
						$sprite.animation = "walking"
					$sprite.play()
				else:
					$sprite.stop()
					idle_time += 1 * delta
					if idle_time >= 0.3:  
						$sprite.animation = "idle"
						
func set_flip(flip):
	$sprite.flip_h = flip

func jump():
	if !Global.GAMEOVER:
		if is_on_floor_custom():
			buff = 0
			Global.play_sound(Global.EnemyJumpSFX, {}, global_position)
			Global.emit(global_position, 2)
			velocity.y = jump_speed

func _on_area_body_entered(body):
	if !dead and !attached and blowed <= 0:
		if body and body.is_in_group("players"):
			z_index = 0
			$sprite.animation = "killing"
			$sprite.play()
			attached = true
			body.attached(self)
			$AreaDetect.set_deferred("disabled", true)
			$collider.set_deferred("disabled", true)
			$Area/collider.set_deferred("disabled", true)

func kill_fire(tt_total = null):
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
	$sprite.animation = "dead_fire"
	$sprite.play()
	set_collision_layer_value(5, true)
	set_collision_mask_value(5, true)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
func hearing_alerted(_body):
	pass
	
func eat_gizmo(_current_item):
	killing = total_killing
	
func kill_fall():
	visible = false
	queue_free()

func flyaway(_direction):
	if blowed <= 0:
		blowed = 6.2
		Global.emit(global_position, 2)
		velocity = Global.flyaway(_direction, jump_speed)
		previus_velocity = velocity

func super_jump():
	if attached:
		$sprite.animation = "idle"
		$AreaDetect.set_deferred("disabled", false)
		$collider.set_deferred("disabled", false)
		$Area/collider.set_deferred("disabled", false)
		attached = false
	Global.emit(global_position, 2)
	velocity.y = jump_speed * 2

func _on_area_detect_body_entered(body):
	if !dead and !attached:
		if body and body.is_in_group("players"):
			jumping = true

func _on_area_detect_body_exited(body):
	if !dead and !attached:
		if body and body.is_in_group("players"):
			jumping = false
