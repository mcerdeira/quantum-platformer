extends CharacterBody2D
var gravity_total = 10.0
var gravity = 10.0
var speed_original = 215.0
var speed = speed_original
var jump_speed_original = -350.0
var jump_speed = jump_speed_original
var locked_ctrls = false
var force_lookup = false
var rainobj = preload("res://scenes/Rain.tscn")
var rain = null
var faceoverride = ""
var do_dialog_final_boss = false

@export var direction = "right"
var has_hammer = false
var first_fall = true
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
var is_on_plant_stair = false
var grabbed = false
var LineTrayectory = null
var dead_fall = false
var dead_animation = "dead"
const blood = preload("res://scenes/blood.tscn")
var fires = preload("res://scenes/Fires.tscn")
var ghost = preload("res://scenes/player_ghost.tscn")
var fire_obj = null
var level_parent = null
var idle_play_total = 4 
var idle_play = idle_play_total
var dont_camera = false
var gravityon = true
var cameralimits_on = true
var terminal_mode = false
var double_jumped = false
var selector_visibility_ttl = 0
#PERKS
var double_jump = false
var invisible = false
var resurrect = false
var radar = false
var binocular = false
var lifes = 1
var resurrecting = 0
var ghost_inst = null
var look_counter_total = 0.4
var look_counter = 0.0

var last_input_time = 0.0
var shake_count = 0.9
var shake_timeout = 1.1
var required_shakes = 2
var pending_reactivate = 0

var last_safe_position = null
var enemy_attached = null
var message_timeout = 4.5
var jumping = false
var restore_camera_zoom_ttl = 2.1
var restore_camera_zoom = false

var CustomCamera : Camera2D = null

func calc_perks():
	double_jump = Global.find_my_item("wings")
	invisible = Global.find_my_item("invisibility") 
	resurrect = Global.find_my_item("resurrect")
	radar = Global.find_my_item("radar")
	binocular = Global.find_my_item("binocular")
	if resurrect:
		lifes = 2

func _ready():
	calc_perks()
	last_safe_position = global_position
	
	if direction == "left":
		$sprite.flip_h = true
		$sprite_eyes.flip_h = $sprite.flip_h
		$gun_sprite.rotation = initial_rotation - 45
	elif direction == "right":
		$sprite.flip_h = false
		$sprite_eyes.flip_h = $sprite.flip_h
		$gun_sprite.rotation = initial_rotation
	
	add_to_group("players")
	$sprite.animation = "idle"
	$sprite_eyes.animation = $sprite.animation
	
	#$gun_sprite.visible = true
	$gun_sprite.rotation = initial_rotation
	$Cosito.play()
	$Cosito.visible = false
	LineTrayectory = $Line2D
	if !iam_clone:
		Global.shaker_obj.camera = $Camera2D
		Global.player_obj = self
		Global.Fader.fade_out()
		if Global.TerminalNumber == Global.TerminalsEnum.MERMAID and Global.CurrentState != Global.GameStates.OVERWORLD:
			rain = rainobj.instantiate()
			rain.position = Vector2(-431, -467) 
			add_child(rain)
			
	if invisible:
		set_invisible(true)
	
func hide_eyes():
	#Ocultar los ojos cuando estamos entrando a una puerta
	$sprite_eyes.visible = false
	
func show_eyes():
	$sprite_eyes.visible = true
	
func restart_camera(_camera_prev_status, show_3ditem = false):
	await get_tree().create_timer(2.1).timeout
	_camera_prev_status.enabled = false
	restore_camera_zoom = true
	$Camera2D.zoom = _camera_prev_status.zoom
	$Camera2D.global_position = _camera_prev_status.global_position
	$Camera2D.enabled = true
	Global.shaker_obj.camera = $Camera2D
	if show_3ditem:
		show_current_item3D()
	
func show_current_item3D(forceitem = -1, wait = true):
	var itemfound = load("res://scenes/Item3D.tscn")
	if wait:
		await get_tree().create_timer(5.0).timeout
	var p = itemfound.instantiate()
	p.global_position.y = 150
	p.global_position.x = Global.pauseobj.global_position.x
	p.forceitem = forceitem
	var parent = Global.pauseobj.get_parent()
	parent.add_child(p)

func show_message_demo():
	await get_tree().create_timer(4).timeout
	$display.visible = true
	$display/back/lbl_item.text = "Hasta aqui la demo.\n¡Gracias por jugar!!"
	
func show_message_custom(_msg, override_time = null):
	$display.visible = true
	$display/back/lbl_item.text = _msg
	var timeout = message_timeout
	if override_time:
		timeout = override_time
	
	await get_tree().create_timer(timeout).timeout
	$display.visible = false 
	
func face_override(str):
	faceoverride = str
	
func show_message_bonus():
	if Global.CurrentState == Global.GameStates.OVERWORLD:
		if Global.FromBonus:
			Global.OverWorldFromGameOver = false
			Global.FromBonus = false
			$display.visible = true
			if randi() % 2 == 0:
				$display/back/lbl_item.text = "Interesante... y ¡RARO!"
			else:
				$display/back/lbl_item.text = "Bueno, al menos consegui moneditas..."
				
			await get_tree().create_timer(message_timeout).timeout
			$display.visible = false
			
func showing_message():
	return $display.visible
	
func show_message_death():
	if Global.CurrentState == Global.GameStates.OVERWORLD:
		if Global.OverWorldFromGameOver:
			$display.visible = true
			Global.OverWorldFromGameOver = false
			Global.FromBonus = false
			if Global.FirstDeath:
				$display/back/lbl_item.text = "¿Que fue eso?\n\n¿Acaso morí?"
				await get_tree().create_timer(message_timeout).timeout
				Global.FirstDeath = false
			
			if randi() % 2 == 0:
				$display/back/lbl_item.text = "¡Que sueño mas loco!"
			else:
				if randi() % 2 == 0:
					$display/back/lbl_item.text = "¡Una P E S A D I L L A!"
				else:
					$display/back/lbl_item.text = "Fue un sueño... ¿NO?"
				
			await get_tree().create_timer(message_timeout).timeout
			$display.visible = false
	
func is_on_floor_custom():
	var real_of = is_on_floor()
	return real_of or buff > 0
	
func update_trayectory(delta):
	LineTrayectory.visible = true 
	LineTrayectory.update_trayectory(Vector2.from_angle($gun_sprite.rotation) * tspeed, delta)
	
func get_hammer():
	has_hammer = true

func destroy_trayectory():
	LineTrayectory.visible = false 
	LineTrayectory.clear_points()
	
func center_camera():
	$Camera2D.position = Vector2.ZERO

func _physics_process(delta):
	if restore_camera_zoom:
		restore_camera_zoom_ttl -= 1 * delta
		if restore_camera_zoom_ttl <= 0:
			cameralimits_on = true
			$Camera2D.zoom = lerp($Camera2D.zoom, Vector2(1, 1), 0.01)
			$Camera2D.position.y  = lerp($Camera2D.position.y, -100.00, 0.1)
	
	if enemy_attached != null:
		jump_speed = jump_speed_original / 2
		speed = speed_original / 2
	else:
		jump_speed = jump_speed_original
		speed = speed_original
		
	if fire_obj and is_instance_valid(fire_obj):
		if randi() % 10 == 0:
			Global.emit(Vector2(global_position.x, global_position.y - 16), 3)
	
	if terminal_mode:
		return
	
	if !iam_clone:
		if dead and resurrect and resurrecting <= 0:
			lifes -= 1
			if lifes <= 0:
				dead = true
			else:
				Global.shaker_obj.shake(3, 2.1)
				ghost_inst = ghost.instantiate()
				ghost_inst.global_position = global_position
				get_parent().add_child(ghost_inst)
				resurrecting = 5
		
		Global.GAMEOVER = dead
		if Global.GAMEOVER:
			Global.OverWorldFromGameOver = true
			
	if has_hammer:
		if direction == "right":
			$Hammer_R.visible = true
			$Hammer_L.visible = false
		else:
			$Hammer_R.visible = false
			$Hammer_L.visible = true
		
	if resurrecting > 0:
		if fire_obj != null and is_instance_valid(fire_obj):
			fire_obj.kill_me = null
			fire_obj.queue_free()
			fire_obj = null
		
		Global.GAMEOVER = false
		resurrecting -= 1 * delta
		ghost_inst.resurrecting = resurrecting
		if resurrecting <= 0:
			Global.play_sound(Global.ResurrectSFX)
			Global.shaker_obj.shake(3, 2.1)
			visible = true
			$sprite.animation = idle_animation
			$sprite_eyes.animation = $sprite.animation
			dead_fall = false
			dead = false
			global_position = ghost_inst.global_position
			ghost_inst.queue_free()
			ghost_inst = null
			pending_reactivate = 1
			
	if pending_reactivate > 0:
		pending_reactivate -= 1 * delta
		if pending_reactivate <= 0:
			set_collision_layer_value(1, true)
			set_collision_mask_value(1, true)
			set_collision_layer_value(2, false)
			set_collision_mask_value(2, false)
	
	if dead and is_on_stairs:
		jumping = false
		velocity = Vector2.ZERO
	
	if dead_fall:
		jumping = false
		velocity = Vector2.ZERO
		return
		
	if binocular:
		if Input.is_action_just_released("zoomin"):
			if Global.CurrentState == Global.GameStates.RANDOMLEVEL:
				Global.play_sound(Global.BinocularSFX)
				Global.BinocularFade.blink()
			else:
				Global.player_obj.show_message_custom("No puedo usar eso aqui.")
		
	$Cosito.visible = !iam_clone and !dead
	if is_on_floor() or grabbed:
		last_safe_position = global_position
		if in_air:
			in_air = false
			double_jumped = false
			
			$sprite_eyes.position.y = 3
			
			if !cameralimits_on:
				velocity.x = 0
				Global.play_sound(Global.BigFallSFX)
				Global.shaker_obj.shake(10, 2.1)
				Global.emit(global_position, 3)
				blowed = 5
				first_fall = false
			else:
				if !first_fall:
					Global.emit(global_position, 1)
					jumping = false
					Global.play_sound(Global.FallSFX)
				else:
					first_fall = false
			
		buff = 0.2
	else:
		in_air = true
		buff -= 1 * delta
	
	if !is_on_floor_custom() and !grabbed:
		if gravityon:
			if velocity.y < 1080: 
				velocity.y += gravity
				
	if Global.BOSS_ROOM and Global.BOSS_DEAD:
		if fire_obj != null and is_instance_valid(fire_obj):
			fire_obj.extinguish_fire()
			
	if blowed > 0:
		blowed -= 1 * delta
		if fire_obj != null and is_instance_valid(fire_obj):
			fire_obj.extinguish_fire()
			
		if blowed <= 0:
			blowed = 0
			$stars_stunned.visible = false
			$lbl_action.visible = false
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			if !cameralimits_on:
				$sprite_eyes.position.y = 3
				$Camera2D.enabled = true
				$sprite.animation = idle_animation
				cameralimits_on = true
			
		if is_on_wall():
			velocity.x = (previus_velocity.x / 2) * -1
		else:
			if is_on_floor():
				velocity.x = lerp(velocity.x, 0.0, 0.04)
			previus_velocity = velocity
	else:
		if grabbed and !Input.is_action_pressed("up") and !Input.is_action_pressed("jump") and !Input.is_action_pressed("down"):
			velocity.y = 0
		
		if !shoot_mode and !Input.is_action_pressed("left") and !Input.is_action_pressed("right"):
			if !is_on_floor_custom():
				velocity.x = lerp(velocity.x, 0.0, friction / 2)
			else:
				velocity.x = lerp(velocity.x, 0.0, friction)
		elif shoot_mode:
			velocity.x = lerp(velocity.x, 0.0, friction / 2)
		
	process_player(delta)
	move_and_slide()
	if faceoverride != "":
		$sprite_eyes.animation = faceoverride
	
func enable_camera(val):
	$Camera2D.enabled = val 
	
func swap_camera():
	$Camera2D.enabled = !$Camera2D.enabled
	
func attached(_enemy_attached):
	enemy_attached = _enemy_attached
	
func camera_limits():
	if cameralimits_on and !CustomCamera:
		if direction == "right":
			$Camera2D.position.x = lerp($Camera2D.position.x, 200.00, 0.01)
		else:
			$Camera2D.position.x = lerp($Camera2D.position.x, -200.00, 0.01)
		
		if !Global.BOSS_ROOM:
			if $Camera2D.global_position.x < 446:
				$Camera2D.global_position.x = 446
				
			if $Camera2D.global_position.x > 4152:
				$Camera2D.global_position.x = 4152
				
			if $Camera2D.global_position.y < 176:
				$Camera2D.global_position.y = 176
				
			if $Camera2D.global_position.y > 2450:
				$Camera2D.global_position.y = 2450
				
func check_shoot_released(delta):
	var shoot_released = Input.is_action_just_released("shoot")	
		
	if !dead and shoot_mode and (shoot_released or blowed > 0):
		if !Global.gunz_equiped[Global.gunz_index].pasive:
			if Global.gunz_equiped[Global.gunz_index].stock > 0:
				idle_play = idle_play_total
				Engine.time_scale = 1.0
				destroy_trayectory()
				shoot_mode = false
				shoot(delta)
				Global.remove_item()
				await get_tree().create_timer(0.3).timeout
				$collider.set_deferred("disabled", false)
				gravity = gravity_total
			
func inv_move_right():
	if Global.gunz_equiped.size() > 0:
		var last_element = Global.gunz_equiped[Global.gunz_equiped.size() - 1]
		for i in range(Global.gunz_equiped.size() - 1, 0, -1):
			Global.gunz_equiped[i] = Global.gunz_equiped[i - 1]
		Global.gunz_equiped[0] = last_element
		#for i in range(0, Global.gunz_equiped.size()):
			#if Global.gunz_equiped[i].name == "muffin":
				#print(Global.gunz_equiped[i].name + "<")
			#else:
				#print(Global.gunz_equiped[i].name)
		#print("-----------")
		
	
func inv_move_left():
	if Global.gunz_equiped.size() > 0:
		var first_element = Global.gunz_equiped[0]
		for i in range(1, Global.gunz_equiped.size()):
			Global.gunz_equiped[i - 1] = Global.gunz_equiped[i]
		Global.gunz_equiped[Global.gunz_equiped.size() - 1] = first_element
		#for i in range(0, Global.gunz_equiped.size()):
			#if Global.gunz_equiped[i].name == "muffin":
				#print(Global.gunz_equiped[i].name + "<")
			#else:
				#print(Global.gunz_equiped[i].name)
		#print("-----------")
		
func refresh_item():
	#Solo para el cheats
	$Selector.refresh_item()
	
func start_dialog_final_boss():
	locked_ctrls = true
	face_override("scared")
	idle_time = -10
	await get_tree().create_timer(3.5).timeout
	show_message_custom("Estoy devastado... pobre pepito...", 3.0)
	await get_tree().create_timer(3.0).timeout
	show_message_custom("Al menos encontre como volver.", 3.0)
	await get_tree().create_timer(3.0).timeout
	show_message_custom("Y por el camino me tope con otro de estos...", 3.0)
	await get_tree().create_timer(3.0).timeout
	show_message_custom("...", 3.0)
	await get_tree().create_timer(3.0).timeout
	show_message_custom("Ya tengo... ¿Cuatro?", 3.0)
	await get_tree().create_timer(3.0).timeout
	show_current_item3D(Global.TerminalsEnum.SALAMANDER, false)
	face_override("")
	locked_ctrls = false
	idle_time = 0

func process_player(delta):
	if do_dialog_final_boss:
		do_dialog_final_boss = false
		start_dialog_final_boss()
		
	moving = false
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
		check_shoot_released(delta)
		return
	elif blowed <= 0 and $sprite.animation == "stunned":
		$sprite.animation = idle_animation

	if fire_obj and is_instance_valid(fire_obj):
		var current = fire_obj.get_parent()
		if current:
			fire_obj.reparent(level_parent)
		else:
			level_parent.add_child(fire_obj)
		fire_obj.global_position = global_position
		fire_obj.z_index = z_index + 1
		
	if !dead and !iam_clone:
		if Input.is_action_just_pressed("scroll_L") and !locked_ctrls:
			$Selector.modulate.a = 1
			selector_visibility_ttl = 2
			Global.gunz_index = 0
			
			inv_move_left()
			
			$Cosito.visible = false
			$Selector.visible = true
			$Selector.refresh_item()
			get_parent().setHUD(false, false)
		if Input.is_action_just_pressed("scroll_R") and !locked_ctrls:
			$Selector.modulate.a = 1
			selector_visibility_ttl = 2
			Global.gunz_index = 0

			inv_move_right()
				
			$Cosito.visible = false
			$Selector.visible = true
			$Selector.refresh_item()
			get_parent().setHUD(false, false)
			
		if $Selector.visible and !Input.is_action_pressed("scroll_R") and !Input.is_action_pressed("scroll_L"):
			selector_visibility_ttl -= 1 * delta
			if selector_visibility_ttl <= 0:
				$Selector.modulate.a -= 3 * delta
				if $Selector.modulate.a <= 0:
					$Cosito.visible = true
					$Selector.visible = false
					$Selector.modulate.a = 1
						
		if !iam_clone and radar:
			if Input.is_action_just_pressed("radar") and !locked_ctrls:
				if $Arrow.visible:
					$Arrow.activate(false)
				else:
					$Arrow.activate(true)
					
	if !iam_clone and !dead and Input.is_action_pressed("shoot") and !locked_ctrls:
		if has_hammer:
			if !$AnimHammer.is_playing():
				var options = {"pitch_scale": 1.5}
				Global.play_sound(Global.WhooshSFX, options)
				$AnimHammer.play("new_animation")
		
		if !iam_clone and Global.CurrentState == Global.GameStates.RANDOMLEVEL or Global.BOSS_ROOM:
			if Global.gunz_equiped.size() > 0:
				if !Global.gunz_equiped[Global.gunz_index].pasive:
					if Global.gunz_equiped[Global.gunz_index].stock > 0:
						$Selector.visible = false
						$Cosito.visible = true
						$Selector.modulate.a = 1
						idle_play = idle_play_total
						Engine.time_scale = 0.1
						update_trayectory(delta)
						shoot_mode = true
		else:
			if !iam_clone:
				if !showing_message():
					Global.player_obj.show_message_custom("No quiero usar eso aqui.")
		
	check_shoot_released(delta)
		
	if !iam_clone and !dead and shoot_mode and !locked_ctrls:
		$collider.set_deferred("disabled", true)
		velocity.y = 0
		gravity = 0.0
		if Input.is_action_pressed("down"):
			if direction == "left":
				$gun_sprite.rotation -= 10 * delta
			else:
				$gun_sprite.rotation += 10 * delta
			idle_play = idle_play_total
			update_trayectory(delta)
		elif Input.is_action_pressed("up"):
			if direction == "left":
				$gun_sprite.rotation += 10 * delta
			else:
				$gun_sprite.rotation -= 10 * delta
			idle_play = idle_play_total
			update_trayectory(delta)
	
	if !dead and !shoot_mode and Input.is_action_just_pressed("jump") and !locked_ctrls:
		idle_play = idle_play_total
		if is_on_stairs and grabbed:
			jumping = false
			velocity.y = -speed * 1.1
			Global.emit(global_position, 2)
		else:
			jump(delta)
	
	if jumping and Input.is_action_just_released("jump") and !locked_ctrls:
		jumping = false
		velocity.y = velocity.y / 2
					
	camera_limits()
	
	if $sprite_eyes.position.y != 4:
		if !Input.is_action_pressed("up") and !Input.is_action_pressed("down"):
			look_counter = 0.0
			$sprite_eyes.position.y = lerp($sprite_eyes.position.y, 4.0, 0.1)
			$Camera2D.position.y  = lerp($Camera2D.position.y, -100.00, 0.1)
		
	if !dead:
		if !shoot_mode and Input.is_action_pressed("down") and !locked_ctrls:
			look_counter += 1 * delta
			if is_on_floor_custom() and !dont_camera and look_counter >= look_counter_total:
				$sprite_eyes.position.y = 8
				var sp = 0
				if is_on_stairs:
					sp = 0.01
				else:
					sp = 0.1
		
				$Camera2D.position.y = lerp($Camera2D.position.y, 150.0, sp)
			
		if force_lookup or (!shoot_mode and Input.is_action_pressed("up") and !locked_ctrls):
			if force_lookup:
				look_counter = look_counter_total
			look_counter += 1 * delta
			if is_on_floor_custom() and !dont_camera and look_counter >= look_counter_total:
				$sprite_eyes.position.y = 0
				var sp = 0
				if is_on_stairs:
					sp = 0.01
				else:
					sp = 0.1
				$Camera2D.position.y = lerp($Camera2D.position.y, -250.0, sp)
		
		if !shoot_mode and Input.is_action_pressed("up") and !locked_ctrls:
			idle_play = idle_play_total
			if is_on_stairs:
				grabbed = true 
				moving = true
				idle_time = 0
				velocity.y = -speed
		elif !shoot_mode and Input.is_action_pressed("down") and !locked_ctrls:
			idle_play = idle_play_total
			if is_on_stairs:
				grabbed = true 
				moving = true
				idle_time = 0
				velocity.y = speed
				
		var input_time = Time.get_ticks_msec() / 1000.0
			
		if !shoot_mode and Input.is_action_pressed("left") and !locked_ctrls:
			idle_play = idle_play_total
			check_shake(input_time)
			direction = "left"
			moving = true
			idle_time = 0
			velocity.x = lerp(velocity.x, -speed, 0.7)
			$sprite.flip_h = true
			$sprite_eyes.flip_h = $sprite.flip_h
			$gun_sprite.rotation = initial_rotation - 45
			
		elif !shoot_mode and Input.is_action_pressed("right") and !locked_ctrls:
			idle_play = idle_play_total
			check_shake(input_time)
			direction = "right"
			moving = true
			idle_time = 0
			velocity.x = lerp(velocity.x, speed, 0.7)
			$sprite.flip_h = false
			$sprite_eyes.flip_h = $sprite.flip_h
			$gun_sprite.rotation = initial_rotation
			
	#Control SFX walk and stairs
	if moving and !in_air:
		if !in_air and $WalkSoundTimer.is_stopped():
			$WalkSoundTimer.start()
	else:
		if !$WalkSoundTimer.is_stopped():
			if in_air:
				await get_tree().create_timer(0.3).timeout
			$WalkSoundTimer.stop()

	if gravityon:
		idle_play -= 1 * delta
	
	if !gravityon:
		moving = false
		
	if enemy_attached != null and is_instance_valid(enemy_attached):
		enemy_attached.z_index = z_index + 1
		enemy_attached.set_flip($sprite.flip_h)
		enemy_attached.position = Vector2(position.x, position.y - 28)
	
	if !dead:
		if moving:
			if $sprite.animation == idle_animation:
				if idle_animation == "invisible":
					im_invisible = false
					
				$sprite.animation = "walking"
				$sprite_eyes.animation = $sprite.animation

			var ra : RayCast2D
			if direction == "right":
				ra = $raycastR
			else:
				ra = $raycastL
			if ra and ra.is_colliding():
				$sprite_eyes.animation = "angry"
			else:
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
		
func teleported():
	pass
	
func start_dialog_finalboss():
	do_dialog_final_boss = true
	
func lookleft():
	direction = "left"
	$sprite.flip_h = true
	$sprite_eyes.flip_h = $sprite.flip_h
	
func lookright():
	direction = "right"
	$sprite.flip_h = false
	$sprite_eyes.flip_h = $sprite.flip_h
	
func check_shake(current_time):
	if (fire_obj != null and is_instance_valid(fire_obj)) or (enemy_attached != null and is_instance_valid(enemy_attached)):
		if direction == "left" and (Input.is_action_pressed("right") or Input.is_action_pressed("up")) and (current_time - last_input_time) <= shake_timeout:
			shake_count += 1
		elif direction == "right" and (Input.is_action_pressed("left") or Input.is_action_pressed("up")) and (current_time - last_input_time) <= shake_timeout:
			shake_count += 1
		else:
			shake_count = 0
		
		last_input_time = current_time
		
		if shake_count >= required_shakes or (shake_count == 1 and (randi() % 10 == 0)):
			if enemy_attached:
				enemy_attached.super_jump()
				enemy_attached = null
				
			if fire_obj:
				fire_obj.extinguish_fire()
				fire_obj = null
		
func shoot(_delta):
	if !dead:
		if !Global.gunz_equiped[Global.gunz_index].pasive:
			var pos = $Line2D.global_position
			var p = gizmo.instantiate()
			var parent = get_parent()
			p.global_position = pos
			parent.add_child(p)
			Global.emit(pos, 5)
			var current_item = Global.gunz_equiped[Global.gunz_index]
			p.droped(self, $lbl_action, Vector2.from_angle($gun_sprite.rotation) * tspeed, current_item, false)
	
func jump(_delta):
	if !dead and $sprite_eyes.visible:
		var on_floor = is_on_floor_custom()
		if on_floor or (!on_floor and double_jump and !double_jumped):
			if !on_floor:
				double_jumped = true
			buff = 0
			Global.emit(global_position, 2)
			Global.play_sound(Global.JumpSFX)
			jumping = true
			velocity.y = jump_speed
			
func jump_forced():
	if !dead:
		buff = 0
		Global.emit(global_position, 2)
		velocity.y = jump_speed
			
func super_jump():
	if !dead:
		buff = 0
		Global.emit(global_position, 2)
		velocity.y = jump_speed * 2
		
func mini_jump():
	if !dead:
		buff = 0
		Global.emit(global_position, 2)
		velocity.y = jump_speed / 2

func do_action(_delta):
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
	
func flyaway(_direction):
	if blowed <= 0:
		blowed = 6.2
		Global.emit(global_position, 2)
		velocity = Global.flyaway(_direction, jump_speed)
		previus_velocity = velocity
		
func miniflyaway(_direction):
	if blowed <= 0:
		blowed = 2.0
		Global.emit(global_position, 2)
		velocity = Global.flyaway(_direction, jump_speed)
		previus_velocity = velocity

func bleed(count):
	Global.play_sound(Global.PlayerBleedSFX)
	for i in range(count):
		var blood_instance : Area2D = blood.instantiate()
		blood_instance.global_position = global_position
		#get_parent().add_child(blood_instance)
		get_parent().call_deferred("add_child", blood_instance)
		
func kill_fall():
	dead = true
	visible = false
	dead_fall = true

func kill():
	dead = true
	bleed(45)
	await get_tree().create_timer(2).timeout
	bleed(25)
	
func eated():
	visible = false
	dead = true
	bleed(45)
	await get_tree().create_timer(2).timeout
	bleed(25)
	
func dead_fire():
	if Global.TerminalNumber != Global.TerminalsEnum.MERMAID:
		if Global.BOSS_ROOM and Global.BOSS_DEAD:
			if fire_obj != null and is_instance_valid(fire_obj):
				fire_obj.extinguish_fire()
		else:
			Global.play_sound(Global.LavaFallSFX)
			dead = true
			dead_animation = "dead_fire"
	
func reset_to_last():
	Global.play_sound(Global.PlayerHurtSFX)
	global_position = last_safe_position
	blowed = 1.1
	velocity = Vector2.ZERO
	$AnimationPlayer.play("reset_position")

func kill_fire(tt_total = null):
	if fire_obj == null or !is_instance_valid(fire_obj):
		if level_parent:
			Global.play_sound(Global.LavaFallSFX)
			Global.emit(global_position, 10)
			if blowed <= 0:
				show_message_custom("¡¡AHH!! ¡¡SACUDIME!!!", 2.1)
			var parent = level_parent
			var p = fires.instantiate()
			if tt_total != null:
				p.tt_total = tt_total
				
			p.global_position = global_position
			p.kill_me = self
			#parent.add_child(p)
			parent.call_deferred("add_child", p)
			fire_obj = p

func _on_walk_sound_timer_timeout():
	if !dead and blowed <= 0:
		var options = {"pitch_scale": Global.pick_random([0.5, 0.7])}
		if is_on_stairs and grabbed:
			Global.play_sound(Global.ClimbSFX, options)
		else:
			Global.play_sound(Global.WalkSFX,options)
