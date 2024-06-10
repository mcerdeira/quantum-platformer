extends CharacterBody2D
var gravity = 10.0
var speed = 125.0
var jump_speed = -300.0
@export var direction = "right"
var total_friction = 0.3
var im_invisible = false
var friction = total_friction
var moving = false
var buff = 0
var in_air = false
var idle_time = 0
var tspeed = 370.0
var dead = false
var blowed = 0
const blood = preload("res://scenes/blood.tscn")
var previus_velocity = Vector2.ZERO
var trapped = true
var dir = 1
var liberating = 0
var help_messages = ["HELP!", "SAVE ME!", "S.O.S"]
var thanks_messages = ["THANKS!", "MY HERO!"]
var thanks_message = Global.pick_random(thanks_messages)
var is_on_stairs = false
var grabbed = false
var dead_animation = "dead"
var fires = preload("res://scenes/Fires.tscn")
var fire_obj = null
var level_parent = null
var delay_time = 0
var command = null

func _ready():
	add_to_group("players")
	add_to_group("prisoners")
	$sprite.animation = "trapped"
	$sprite.play()
	$lbl_action.text = Global.pick_random(help_messages)
	
func is_on_floor_custom():
	return is_on_floor() or buff > 0

func _physics_process(delta):
	if trapped:
		if liberating > 0:
			$lbl_action.text = thanks_message
			liberating -= 1 * delta
			if liberating <= 0:
				set_collision_layer_value(6, true)
				set_collision_mask_value(6, true)
				set_collision_layer_value(1, false)
				set_collision_mask_value(1, false)
				set_collision_layer_value(4, false)
				set_collision_mask_value(4, false)
				
				Global.prisoner_counter -= 1
				$trapped_area.queue_free()
				$collider.set_deferred("disabled", false)
				trapped = false
				$sprite.animation = "idle"
				$lbl_action.text = ""
				$lbl_action.visible = false
	else:
		if fire_obj and is_instance_valid(fire_obj):
			fire_obj.reparent(level_parent)
			fire_obj.global_position = global_position
			fire_obj.z_index = z_index + 1
	
		if is_on_floor():
			if in_air:
				in_air = false
				Global.emit(global_position, 1)
			buff = 0.2
		else:
			in_air = true
			buff -= 1 * delta
		
		if !is_on_floor_custom():
			velocity.y += gravity

		if blowed > 0:
			blowed -= 1 * delta
			if is_on_wall():
				velocity.x = (previus_velocity.x / 2) * -1
			else:
				previus_velocity = velocity
		else:
			if !is_on_floor_custom():
				velocity.x = lerp(velocity.x, 0.0, friction / 10)
			else:
				velocity.x = lerp(velocity.x, 0.0, friction)
			
		process_player(delta)
		move_and_slide()

func process_player(delta):
	var moving = false
	if dead:
		set_collision_layer_value(5, true)
		set_collision_mask_value(5, true)
		set_collision_layer_value(6, false)
		set_collision_mask_value(6, false)
		velocity.x = 0
		
	if !dead:
		if blowed > 0:
			$lbl_action.visible = true
			$lbl_action.visible = false
			$stars_stunned.visible = true
			
			blowed -= 1 * delta
			if blowed <= 0:
				$stars_stunned.visible = false
				$lbl_action.visible = false
			return
			
		$lbl_action.text = str((Time.get_ticks_msec()  / 1000) - delay_time)
		$lbl_action.visible = true
		
		var jump = false
		var left = false
		var right = false
		var up = false
		var down = false
		
		var new_command = Global.commands.get((Time.get_ticks_msec()  / 1000) - delay_time)
		if new_command:
			command = new_command
			
		if command:
			var cmd = command.split("|")
			for c in cmd:
				if c == "jump":
					jump = true
				if c == "up":
					up = true
				if c == "down":
					down = true
				if c == "left":
					left = true
				if c == "right":
					right = true
			
		if jump:
			if is_on_stairs and grabbed:
				velocity.y = -speed * 1.1
				Global.emit(global_position, 2)
			else:
				jump(delta)
			
		if up:
			if is_on_stairs:
				grabbed = true 
				moving = true
				idle_time = 0
				velocity.y = -speed
		elif down:
			if is_on_stairs:
				grabbed = true 
				moving = true
				idle_time = 0
				velocity.y = speed
		
		if left:
			direction = "left"
			moving = true
			idle_time = 0
			velocity.x = lerp(velocity.x, -speed, 0.7)
			$sprite.flip_h = true
			
		elif right:
			direction = "right"
			moving = true
			idle_time = 0
			velocity.x = lerp(velocity.x, speed, 0.7)
			$sprite.flip_h = false
		
		if moving:
			if $sprite.animation == "idle":
				$sprite.animation = "walking"
			$sprite.play()
		else:
			$sprite.stop()
			idle_time += 1 * delta
			if idle_time >= 0.3:  
				$sprite.animation = "idle"
	else:
		$sprite.animation = dead_animation
		$sprite.play()
		
func jump(delta):
	if !dead:
		if is_on_floor_custom():
			buff = 0
			Global.play_sound(Global.JUMP_SFX)
			Global.emit(global_position, 2)
			velocity.y = jump_speed

func lbl_hide_delegate(value, time):
	await get_tree().create_timer(time).timeout
	$lbl_action.visible = value
	
func flyaway(direction):
	if blowed <= 0:
		$stars_stunned.visible = true
		blowed = 6.2
		Global.emit(global_position, 2)
		velocity = Global.flyaway(direction, jump_speed)
		previus_velocity = velocity

func bleed(count):
	for i in range(count):
		var blood_instance : Area2D = blood.instantiate()
		blood_instance.global_position = global_position
		get_parent().add_child(blood_instance)

func kill_fall():
	dead = true
	visible = false
	queue_free()

func kill():
	dead = true
	bleed(45)
	await get_tree().create_timer(2).timeout
	bleed(25)
	
func kill_fire():
	if fire_obj == null:
		Global.emit(global_position, 10)
		var parent = level_parent
		var p = fires.instantiate()
		parent.add_child(p)
		p.global_position = global_position
		p.kill_me = self
		fire_obj = p
	
func dead_fire():
	dead = true
	dead_animation = "dead_fire"

func super_jump():
	if !dead:
		buff = 0
		Global.play_sound(Global.JUMP_SFX)
		Global.emit(global_position, 2)
		velocity.y = jump_speed * 2

func _on_trapped_area_body_entered(body):
	if body.is_in_group("players"):
		liberating = 2.0
		delay_time = (Time.get_ticks_msec()  / 1000)
		print(delay_time)
