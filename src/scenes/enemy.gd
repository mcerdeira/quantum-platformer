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
var total_killing = 4
var killing = 0
var direction_change_ttl_total = 4
var direction_change_ttl = direction_change_ttl_total
var alerted = false
var blowed = 0
var alerted_delay = 0
var previus_velocity = Vector2.ZERO

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
	
	if !is_on_floor_custom():
		velocity.y += gravity
	else:
		if friction != total_friction:
			friction = lerp(friction, total_friction, 0.01)
	
	if blowed <= 0:
		velocity.x = lerp(velocity.x, 0.0, friction)
	else:
		blowed -= 1 * delta
		if is_on_wall():
			velocity.x = (previus_velocity.x / 2) * -1
		else:
			previus_velocity = velocity

	process_player(delta)
	move_and_slide()

func process_player(delta):
	var moving = false
	if blowed > 0:
		$lbl_status.text = "@"
		$lbl_status.set("theme_override_colors/font_color", Color.AQUAMARINE)
		blowed -= 1 * delta
		alerted = false
		hostile = true
		return
		
	if Global.GAMEOVER:
		hostile = false
		alerted = false
		
	if hostile:
		alerted = false
	
	if killing > 0:
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
		if is_on_floor_custom() and Global.time_speed == 1.0: 
			buff = 0
			Global.play_sound(Global.JUMP_SFX)
			Global.emit(global_position, 2)
			velocity.y = jump_speed

func _on_area_body_entered(body):
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
			
func still_alert():
	current_target_alerted = null
	alerted = false
	
func kill_fall():
	visible = false
	queue_free()

func flyaway(direction):
	if blowed <= 0:
		blowed = 3.2
		Global.emit(global_position, 2)
		velocity = Global.flyaway(direction, jump_speed)
