extends CharacterBody2D
var gravity = 10.0
var total_speed = 230.0
var speed = total_speed
var jump_speed = -300.0
@export var direction = ""
var total_friction = 0.6
var friction = total_friction
var moving = false
var buff = 0
var in_air = false
var idle_time = 0
var tspeed = 370.0
var initial_rotation = 0
var hostile = false
var jump_delay = 0
var current_target = null
var current_target_alerted = null
var check_delay = 1
var total_killing = 6
var killing = 0
var do_when_finish_killing = ""
var direction_change_ttl_total = 4
var direction_change_ttl = direction_change_ttl_total
var alerted = false
var blowed = 0
var alerted_delay = 0
var previus_velocity = Vector2.ZERO
var fire_obj = null
var level_parent = null
var dead = false
var jumper = false
var sleep = false
var fires = preload("res://scenes/Fires.tscn")
var enemy = load("res://scenes/enemy.tscn")

func _ready():
	add_to_group("enemies")
	$sprite.animation = "idle"
	
func is_on_floor_custom():
	return is_on_floor() or buff > 0

func _physics_process(delta):
	speed = total_speed * Global.time_speed
	if is_on_floor():
		if in_air:
			check_delay = 0.1
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
	
	if !is_on_floor_custom():
		velocity.y += gravity
	
	if blowed > 0:
		blowed -= 1 * delta
		if is_on_wall():
			velocity.x = (previus_velocity.x / 2) * -1
		else:
			previus_velocity = velocity
			
		if blowed <= 0:
			if fire_obj != null and is_instance_valid(fire_obj):
				hostile = true
			
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
	
	$Agro/Vision.visible = !hostile
	
	if sleep:
		$sprite.animation = "sleep"
		$stars_stunned.animation = "sleep"
		$stars_stunned.visible = true
		$lbl_status.text = ""
		alerted = false
		hostile = false
		return
	
	if blowed > 0:
		$sprite.animation = "stunned"
		$stars_stunned.animation = "stunned"
		$stars_stunned.visible = true
		$lbl_status.text = ""
		alerted = false
		hostile = false
		return
		
	if dead:
		$AnimationPlayer.stop()
		$stars_stunned.visible = false
		$lbl_status.text = ""
		hostile = false
		alerted = false
		$Agro/Vision.visible = false
		return
		
	if Global.GAMEOVER:
		hostile = false
		alerted = false
		
	if hostile:
		alerted = false
	
	if killing > 0:
		$Agro/Vision.visible = false
		killing -= 1 * delta 
		alerted = false
		hostile = false
		$lbl_status.text = "!"
		$lbl_status.set("theme_override_colors/font_color", Color.RED)
		if $sprite.animation != "killing":
			$AnimationPlayer.play("killing")
			$sprite.animation = "killing"
			$sprite.play()
		
		if killing <= 0:
			$AnimationPlayer.stop()
			$sprite.animation = "idle"
			hostile = true
			killing = 0
			if do_when_finish_killing != "":
				if do_when_finish_killing == "teleport":
					var where = Vector2(Global.player_obj.global_position.x - 32, Global.player_obj.global_position.y - 32)
					Global.emit(global_position, 10)
					global_position = where
				elif do_when_finish_killing == "clone":
					var where = Vector2(global_position.x - 32, global_position.y - 32)
					Global.emit(where, 10)
					var Main = get_node("/root/Main")
					var pclone = enemy.instantiate()
					pclone.global_position = where
					Main.add_child(pclone)
				elif do_when_finish_killing == "bomb":
					pass
				elif do_when_finish_killing == "smoke":
					pass
				elif do_when_finish_killing == "muffin":
					sleep = true
					$sprite.animation = "sleep"
					$sprite.play()
				elif do_when_finish_killing == "spring":
					jumper = true
				elif do_when_finish_killing == "plant":
					sleep = true
					$sprite.animation = "sleep"
					$sprite.play()
	
	if alerted:
		$lbl_status.text = "?"
		$lbl_status.set("theme_override_colors/font_color", Color.YELLOW)
		
		if alerted_delay > 0:
			alerted_delay -= 1 * delta
			
		if alerted_delay <= 0:
			if current_target_alerted != null and is_instance_valid(current_target_alerted):
				if global_position.x > current_target_alerted.global_position.x:
					direction = "left"
				else:
					direction = "right"
					
				if is_on_wall():
					jump(delta)
					if randi() % 10 == 0:
						alerted = false
						current_target_alerted = null
						current_target = null
				
				if direction == "right":
					moving = true
					idle_time = 0
					velocity.x = speed / 4
					$sprite.flip_h = false
					$Agro.scale.x = 1
				else:
					moving = true
					idle_time = 0
					velocity.x = -speed / 4
					$sprite.flip_h = true
					$Agro.scale.x = -1
				
	elif hostile and killing <= 0:
		$lbl_status.text = "!"
		$lbl_status.set("theme_override_colors/font_color", Color.RED)
		
		if Input.is_action_just_pressed("jump"):
			jump_delay = 0.01
			
		if jumper:
			jump(delta)
		else:
			if jump_delay > 0 or randi() % 1500 == 0:
				jump_delay -= 1 * delta
				if jump_delay <= 0:
					jump(delta)
				
		if current_target == null or current_target.dead or !is_instance_valid(current_target):
			if !Global.targets.is_empty():
				current_target = Global.pick_random(Global.targets)
			else:
				hostile = false
			
		if current_target != null and is_instance_valid(current_target):
			if global_position.y > current_target.global_position.y:
				if randi() % 5 == 0:
					jump(delta)
			
			if is_on_wall():
				jump(delta)
				
			if check_delay > 0:
				check_delay -= 1 * delta
				if check_delay <= 0:
					check_delay = Global.pick_random([1, 0.5, 2, 2.5])
					if global_position.x > current_target.global_position.x:
						direction = "left"
					else:
						direction = "right"
			
			if direction == "right":
				moving = true
				idle_time = 0
				velocity.x = speed
				$sprite.flip_h = false
				$Agro.scale.x = 1
			else:
				moving = true
				idle_time = 0
				velocity.x = -speed
				$sprite.flip_h = true
				$Agro.scale.x = -1
	else:
		if killing <= 0:
			$lbl_status.text = ""
			
			direction_change_ttl -= 1 * delta
			if direction_change_ttl <= 0:
				direction_change_ttl = direction_change_ttl_total
				if direction == "right":
					direction = "left"
					$sprite.flip_h = true
					$Agro.scale.x = -1
				else:
					direction = "right"
					$sprite.flip_h = false
					$Agro.scale.x = 1
	
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
		
func jump(delta):
	if !Global.GAMEOVER:
		if is_on_floor_custom():
			buff = 0
			Global.play_sound(Global.JUMP_SFX)
			Global.emit(global_position, 2)
			velocity.y = jump_speed

func _on_area_body_entered(body):
	if !dead and !sleep and blowed <= 0:
		if body and body.is_in_group("players"):
			body.kill()
			killing = total_killing
			if global_position.x > body.global_position.x:
				$sprite.flip_h = true
			else:
				$sprite.flip_h = false

func _on_agro_body_entered(body):
	if !hostile:
		current_target = body
		hostile = true

func hearing_alerted(body):
	if !hostile and !alerted:
		alerted_delay = 2
		current_target_alerted = body
		alerted = true
			
func eat_gizmo(current_item):
	current_target_alerted = null
	alerted = false
	hostile = false
	killing = total_killing
	if current_item.name == "teleport":
		do_when_finish_killing = "teleport"
	elif current_item.name == "clone":
		do_when_finish_killing = "clone"
	elif current_item.name == "bomb":
		pass
	elif current_item.name == "smoke":
		pass
	elif current_item.name == "spring":
		do_when_finish_killing = "spring"
	elif current_item.name == "muffin":
		do_when_finish_killing = "muffin"
	elif current_item.name == "plant":
		do_when_finish_killing = "plant"
	
func kill_fall():
	visible = false
	queue_free()
	
func dead_fire():
	dead = true
	$sprite.animation = "dead_fire"
	$sprite.play()
	set_collision_layer_value(5, true)
	set_collision_mask_value(5, true)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)

func kill_fire():
	if fire_obj == null or !is_instance_valid(fire_obj):
		if !hostile:
			hostile = true
			current_target = Global.player_obj
		Global.emit(global_position, 10)	
		var parent = level_parent
		var p = fires.instantiate()
		p.global_position = global_position
		p.kill_me = self
		parent.add_child(p)
		fire_obj = p

func flyaway(direction):
	if blowed <= 0:
		blowed = 6.2
		Global.emit(global_position, 2)
		velocity = Global.flyaway(direction, jump_speed)
		previus_velocity = velocity

func super_jump():
	Global.play_sound(Global.JUMP_SFX)
	Global.emit(global_position, 2)
	velocity.y = jump_speed * 2
