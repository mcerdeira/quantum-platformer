extends CharacterBody2D
var gravity = 10.0
var speed = 215.0
var jump_speed = -300.0
@export var direction = "right"
var total_friction = 0.6
var friction = total_friction
var moving = false
var buff = 0
var in_air = false
var im_invisible = false
var idle_animation = "idle"
var idle_time = 0
var shoot_mode = false
const gizmo = preload("res://scenes/gizmo.tscn")
var tspeed = 700.0
var initial_rotation = -45
var iam_clone = false
var dead = false
var blowed = 0
var previus_velocity = Vector2.ZERO
var is_on_stairs = false
var grabbed = false
var LineTrayectory = null
var dead_fall = false
var dead_animation = "dead"
const blood = preload("res://scenes/blood.tscn")
var fires = preload("res://scenes/Fires.tscn")
var fire_obj = null
var level_parent = null
var idle_play_total = 4 
var idle_play = idle_play_total
var dont_camera = false
var frame = 0
var gravityon = true

func _ready():
	add_to_group("players")
	$sprite.animation = "idle"
	$sprite_eyes.animation = $sprite.animation
	
	$gun_sprite.visible = false
	$gun_sprite.rotation = initial_rotation
	$Cosito.play()
	$Cosito.visible = false
	LineTrayectory = $Line2D
	Global.shaker_obj.camera = $Camera2D
	Global.player_obj = self
	
func hide_eyes():
	$sprite_eyes.visible = false
	
func is_on_floor_custom():
	return is_on_floor() or buff > 0
	
func update_trayectory(delta):
	LineTrayectory.visible = true 
	
	var pos = $gun_sprite/mark.global_position
	LineTrayectory.update_trayectory(Vector2.from_angle($gun_sprite.rotation) * tspeed, delta)

func destroy_trayectory():
	LineTrayectory.visible = false 
	LineTrayectory.clear_points()

func _physics_process(delta):
	if !iam_clone:
		Global.GAMEOVER = dead
	
	if dead and is_on_stairs:
		velocity = Vector2.ZERO
	
	if dead_fall:
		velocity = Vector2.ZERO
		return
		
	if Input.is_action_just_released("zoomin"):
		$Camera2D.zoom += Vector2(10, 10) * delta
	if Input.is_action_just_released("zoomout"):
		$Camera2D.zoom -= Vector2(10, 10) * delta

	$Cosito.visible = !iam_clone and !dead
	if is_on_floor() or grabbed:
		if in_air:
			in_air = false
			Global.emit(global_position, 1)
		buff = 0.2
	else:
		in_air = true
		buff -= 1 * delta
	
	if !is_on_floor_custom() and !grabbed:
		if gravityon:
			velocity.y += gravity

	if blowed > 0:
		blowed -= 1 * delta
		if blowed <= 0:
			$stars_stunned.visible = false
			$lbl_action.visible = false
			
		if is_on_wall():
			velocity.x = (previus_velocity.x / 2) * -1
		else:
			previus_velocity = velocity
	else:
		if grabbed and !Input.is_action_pressed("up") and !Input.is_action_pressed("jump") and !Input.is_action_pressed("down"):
			velocity.y = 0
		
		if !shoot_mode and !Input.is_action_pressed("left") and !Input.is_action_pressed("right"):
			if !is_on_floor_custom():
				velocity.x = lerp(velocity.x, 0.0, friction / 2)
			else:
				velocity.x = lerp(velocity.x, 0.0, friction)
		
	process_player(delta)
	move_and_slide()
	
func enable_camera(val):
	$Camera2D.enabled = val 
	
func camera_limits():
	if direction == "right":
		$Camera2D.position.x = lerp($Camera2D.position.x, 200.00, 0.01)
	else:
		$Camera2D.position.x = lerp($Camera2D.position.x, -200.00, 0.01)
	
	if $Camera2D.global_position.x < 446:
		$Camera2D.global_position.x = 446
		
	if $Camera2D.global_position.x > 4152:
		$Camera2D.global_position.x = 4152
		
	if $Camera2D.global_position.y < 176:
		$Camera2D.global_position.y = 176
		
	if $Camera2D.global_position.y > 2450:
		$Camera2D.global_position.y = 2450

func process_player(delta):
	var moving = false
	if dead:
		velocity.x = 0
		$stars_stunned.visible = false
		blowed = 0
		set_collision_layer_value(2, true)
		set_collision_mask_value(2, true)
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
		
	if blowed > 0:
		$stars_stunned.visible = true
		$sprite.animation = "stunned"
		$sprite_eyes.animation = $sprite.animation
		$lbl_action.visible = false
		idle_play = idle_play_total
		return

	if fire_obj and is_instance_valid(fire_obj):
		fire_obj.reparent(level_parent)
		fire_obj.global_position = global_position
		fire_obj.z_index = z_index + 1
		
	if !dead and !iam_clone:
		if Input.is_action_just_pressed("scroll"):
			if Global.gunz_index == 0:
				Global.gunz_index = 1
			elif Global.gunz_index == 1:
				Global.gunz_index = 0
			get_parent().calc_selected()
			if Global.gunz_equiped[0].name == "invisibility" or Global.gunz_equiped[1].name == "invisibility":
				if Global.gunz_equiped[Global.gunz_index].name == "invisibility":
					set_invisible(true)
				else:
					set_invisible(false)
			
			if Global.gunz_equiped[0].name == "radar" or Global.gunz_equiped[1].name == "radar":
				if Global.gunz_equiped[Global.gunz_index].name == "radar":
					$Arrow.activate(true)
				else:
					$Arrow.activate(false)
	
	if !dead and Input.is_action_pressed("shoot"):
		if !Global.gunz_equiped[Global.gunz_index].pasive:
			if Global.slots_stock[Global.gunz_index] > 0:
				idle_play = idle_play_total
				Global.time_speed = 0.1
				update_trayectory(delta)
				shoot_mode = true
		
	if !dead and shoot_mode and Input.is_action_just_released("shoot"):
		if !Global.gunz_equiped[Global.gunz_index].pasive:
			if Global.slots_stock[Global.gunz_index] > 0:
				idle_play = idle_play_total
				Global.time_speed = 1.0
				#destroy_gizmo_simul()
				destroy_trayectory()
				shoot_mode = false
				shoot(delta)
				Global.remove_item()
				await get_tree().create_timer(0.3).timeout
				$gun_sprite.visible = false
		
	if !dead and shoot_mode:
		if Input.is_action_pressed("left"):
			$gun_sprite.rotation -= 1 * delta
			idle_play = idle_play_total
			update_trayectory(delta)
		elif Input.is_action_pressed("right"):
			$gun_sprite.rotation += 1 * delta
			idle_play = idle_play_total
			update_trayectory(delta)
			
	var some_command = ""
	
	if !dead and Input.is_action_just_pressed("jump"):
		some_command = "jump"
		idle_play = idle_play_total
		if is_on_stairs and grabbed:
			velocity.y = -speed * 1.1
			Global.emit(global_position, 2)
		else:
			jump(delta)
					
	camera_limits()
	
	if $sprite_eyes.position.y != 4:
		if !Input.is_action_pressed("up") and !Input.is_action_pressed("down"):
			$sprite_eyes.position.y = lerp($sprite_eyes.position.y, 4.0, 0.1)
			$Camera2D.position.y  = lerp($Camera2D.position.y, -100.00, 0.1)
		
	if !dead:
		if !shoot_mode and Input.is_action_pressed("down"):
			if is_on_floor_custom() and !dont_camera:
				$sprite_eyes.position.y = 8
				var sp = 0
				if is_on_stairs:
					sp = 0.01
				else:
					sp = 0.1
		
				$Camera2D.position.y = lerp($Camera2D.position.y, 150.0, sp)
			
		if !shoot_mode and Input.is_action_pressed("up"):
			if is_on_floor_custom() and !dont_camera:
				$sprite_eyes.position.y = 0
				var sp = 0
				if is_on_stairs:
					sp = 0.01
				else:
					sp = 0.1
				$Camera2D.position.y = lerp($Camera2D.position.y, -250.0, sp)
		
		if !shoot_mode and Input.is_action_pressed("up"):
			idle_play = idle_play_total
			some_command += "|up"
			if is_on_stairs:
				grabbed = true 
				moving = true
				idle_time = 0
				velocity.y = -speed
		elif !shoot_mode and Input.is_action_pressed("down"):
			idle_play = idle_play_total
			some_command += "|down"
			if is_on_stairs:
				grabbed = true 
				moving = true
				idle_time = 0
				velocity.y = speed
		
		if !shoot_mode and Input.is_action_pressed("left"):
			some_command += "|left"
			idle_play = idle_play_total
			direction = "left"
			moving = true
			idle_time = 0
			velocity.x = lerp(velocity.x, -speed, 0.7)
			$sprite.flip_h = true
			$sprite_eyes.flip_h = $sprite.flip_h
			$gun_sprite.rotation = initial_rotation - 45
			
		elif !shoot_mode and Input.is_action_pressed("right"):
			some_command += "|right"
			idle_play = idle_play_total
			direction = "right"
			moving = true
			idle_time = 0
			velocity.x = lerp(velocity.x, speed, 0.7)
			$sprite.flip_h = false
			$sprite_eyes.flip_h = $sprite.flip_h
			$gun_sprite.rotation = initial_rotation
	
	if gravityon:
		idle_play -= 1 * delta
	
	frame += 1
	
	#$lbl_action.text = str(frame)
	#$lbl_action.visible = true
	
	if !some_command:
		add_to_followers("stop")
	else:
		add_to_followers(some_command)
		
	if !gravityon:
		moving = false
	
	if !dead:
		if moving:
			if $sprite.animation == idle_animation:
				if idle_animation == "invisible":
					im_invisible = false
					
				$sprite.animation = "walking"
				$sprite_eyes.animation = $sprite.animation
			$sprite.play()
		else:
			$sprite.stop()
			if idle_play <= 0:
				$sprite_eyes.play()
			else:
				$sprite_eyes.stop()
			
			if idle_animation == "invisible":
				im_invisible = true
			idle_time += 1 * delta
			if idle_time >= 0.3:
				$sprite.animation = idle_animation
				$sprite_eyes.animation = $sprite.animation
	else:
		$sprite.animation = dead_animation
		$sprite_eyes.animation = $sprite.animation
		$sprite.play()
		
func add_to_followers(cmd):
	var ts = frame
	Global.commands[ts] = cmd
		
func shoot(delta):
	if !dead:
		if !Global.gunz_equiped[Global.gunz_index].pasive:
			var pos = $gun_sprite/mark.global_position
			var p = gizmo.instantiate()
			var parent = get_parent()
			parent.add_child(p)
			p.global_position = pos
			Global.emit(pos, 5)
			var current_item = Global.gunz_equiped[Global.gunz_index]
			p.droped(self, $lbl_action, Vector2.from_angle($gun_sprite.rotation) * tspeed, current_item, false)
	
func jump(delta):
	if !dead:
		if is_on_floor_custom():
			buff = 0
			Global.play_sound(Global.JUMP_SFX)
			Global.emit(global_position, 2)
			velocity.y = jump_speed
			
func super_jump():
	if !dead:
		buff = 0
		Global.play_sound(Global.JUMP_SFX)
		Global.emit(global_position, 2)
		velocity.y = jump_speed * 2

func do_action(delta):
	if !dead:
		Global.GizmoWatcher.do_action(self, $lbl_action)

func lbl_hide_delegate(value, time):
	await get_tree().create_timer(time).timeout
	$lbl_action.visible = value
	
func set_invisible(val):
	if val:
		im_invisible = true
		idle_animation = "invisible"
		$sprite.animation = "invisible"
		$sprite_eyes.animation = $sprite.animation
	else:
		im_invisible = false
		idle_animation = "idle"
		$sprite.animation = "idle"
		$sprite_eyes.animation = $sprite.animation
	
func flyaway(direction):
	if blowed <= 0:
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
	dead_fall = true

func kill():
	dead = true
	bleed(45)
	await get_tree().create_timer(2).timeout
	bleed(25)
	
func dead_fire():
	dead = true
	dead_animation = "dead_fire"

func kill_fire():
	if fire_obj == null or !is_instance_valid(fire_obj):
		Global.emit(global_position, 10)
		var parent = level_parent
		var p = fires.instantiate()
		parent.add_child(p)
		p.global_position = global_position
		p.kill_me = self
		fire_obj = p
