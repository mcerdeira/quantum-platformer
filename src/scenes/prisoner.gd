extends CharacterBody2D
var gravity = 10.0
var total_speed = 25.0
var speed = total_speed
var jump_speed = -300.0
@export var direction = "right"
var direction_change_ttl_total = 1
var direction_change_ttl = direction_change_ttl_total
var total_friction = 0.6
var im_invisible = false
var friction = total_friction
var moving = false
var buff = 0
var in_air = false
var idle_time = 0
var dead = false
var blowed = 0
const blood = preload("res://scenes/blood.tscn")
var npc_obj = preload("res://scenes/prisoner_npc.tscn")
var previus_velocity = Vector2.ZERO
var trapped = true
var dir = 1
var free = false
var liberating = 0
var help_messages = ["¡AYUDA!", "¡SALVAME!", "S.O.S"]
var thanks_messages = ["¡GRACIAS!", "¡ME SALVASTE!", "¡VIVA LA VIDA!"]
var thanks_message = Global.pick_random(thanks_messages)
var is_on_stairs = false
var is_on_plant_stair = false
var grabbed = false
var dead_animation = "dead"
var fires = preload("res://scenes/Fires.tscn")
var ghost = preload("res://scenes/enemy_ghost.tscn")
var fire_obj = null
var level_parent = null
var delay_time = 0
var dead_fall = false
var ghost_created = false
var initial_pos = Vector2.ZERO
var ttl_stop_total = 25
var ttl_stop_total2 = 10
var ttl_stop = Global.pick_random([ttl_stop_total, ttl_stop_total2])
var stoped = false
var stairdetect_ttl = 1
var libetared_ttl = 3
var scaping = false
var scaping_ttl = 3
var var_convert_into_npc = false
var delay_fall = 0

func _ready():
	add_to_group("players")
	add_to_group("prisoners")
	$sprite.animation = "trapped"
	$sprite.play()
	$lbl_action.text = Global.pick_random(help_messages)
	
func is_on_floor_custom():
	return is_on_floor() or buff > 0
	
func convert_into_npc():
	var_convert_into_npc = true
	set_collision_layer_value(6, true)
	set_collision_mask_value(6, true)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	set_collision_layer_value(4, false)
	set_collision_mask_value(4, false)
	liberating = 0.0
	$trapped_area.queue_free()
	$collider.set_deferred("disabled", false)
	trapped = false
	$sprite.animation = "idle"
	$lbl_action.text = ""
	$lbl_action.visible = false

func _physics_process(delta):
	if delay_fall > 0:
		delay_fall -= 1 * delta
		return	
	
	speed = total_speed 
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
				global_position = initial_pos
	else:
		if dead and !ghost_created:
			ghost_created = true
			Global.emit(global_position, 10)
			var parent = level_parent
			var p = ghost.instantiate()
			parent.add_child(p)
			p.global_position = global_position
		
		if dead and is_on_stairs:
			velocity = Vector2.ZERO
		
		if dead_fall:
			velocity = Vector2.ZERO
			return
			
		if is_on_floor() or grabbed:
			if in_air:
				in_air = false
				Global.emit(global_position, 1)
				if var_convert_into_npc:
					var npc = npc_obj.instantiate()
					npc.global_position = global_position + Vector2(0, 16)
					npc.boss_1_npc = true
					get_parent().add_child(npc)
					queue_free()
					
			buff = 0.2
		else:
			in_air = true
			buff -= 1 * delta
		
		if !is_on_floor_custom() and !grabbed and !scaping:
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
			if grabbed: 
				velocity.y = 0
			
			if !is_on_floor_custom():
				velocity.x = lerp(velocity.x, 0.0, friction / 2)
			else:
				velocity.x = lerp(velocity.x, 0.0, friction)
			
		process_player(delta)
		move_and_slide()

func process_player(delta):
	var moving = false
	if dead:
		velocity.x = 0
		$stars_stunned.visible = false
		blowed = 0
		set_collision_layer_value(5, true)
		set_collision_mask_value(5, true)
		set_collision_layer_value(6, false)
		set_collision_mask_value(6, false)
		
	if blowed > 0:
		$stars_stunned.visible = true
		$sprite.animation = "stunned"
		$lbl_action.visible = false
		return
		
	if fire_obj and is_instance_valid(fire_obj):
		var current = fire_obj.get_parent()
		if current:
			fire_obj.reparent(level_parent)
		else:
			level_parent.add_child(fire_obj)
		fire_obj.global_position = global_position
		fire_obj.z_index = z_index + 1
		
	if !dead:
		if scaping:
			velocity = Vector2(0, jump_speed)
			Global.emit(global_position, 2)
			scaping_ttl -= 1 * delta
			if scaping_ttl <= 0:
				queue_free()
		else:
			libetared_ttl -= 1 * delta
			
			if libetared_ttl <= 0:
				Global.play_sound(Global.PrisonerReleasedSFX)
				$collider.set_deferred("disabled", true)
				scaping = true
			
			ttl_stop -= 1 * delta
			if ttl_stop <= 0:
				if stoped:
					if randi() % 4 == 0:
						direction = Global.pick_random(["right", "left"])
				ttl_stop =  Global.pick_random([ttl_stop_total, ttl_stop_total2])
				stoped = !stoped
				if is_on_stairs and is_on_plant_stair and stoped:
					stoped = true 
			
			if !stoped:
				if is_on_stairs and is_on_plant_stair:
					if stairdetect_ttl > 0:
						stairdetect_ttl -= 1 * delta 
				
				if is_on_stairs and is_on_plant_stair and stairdetect_ttl <= 0:
					if !grabbed:
						ttl_stop = Global.pick_random([4.5, 3])
					moving = true
					grabbed = true 
					idle_time = 0
					velocity.y = -speed
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
						else:
							direction = "right"
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
			Global.play_sound(Global.JumpSFX)
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
	dead_fall = true
	queue_free()

func kill():
	dead = true
	bleed(45)
	await get_tree().create_timer(2).timeout
	bleed(25)
	
func kill_fire(tt_total = null):
	if fire_obj == null or !is_instance_valid(fire_obj):
		if level_parent != null:
			Global.emit(global_position, 10)
			var parent = level_parent
			var p = fires.instantiate()
			p.global_position = global_position
			p.kill_me = self
			parent.add_child(p)
			fire_obj = p
	
func dead_fire():
	if Global.TerminalNumber != Global.TerminalsEnum.MERMAID:
		dead = true
		dead_animation = "dead_fire"

func super_jump():
	if !dead:
		buff = 0
		Global.emit(global_position, 2)
		velocity.y = jump_speed * 2

func _on_trapped_area_body_entered(body):
	if body.is_in_group("players"):
		liberate(body)
		
func liberate(body = null):
	free = true
	direction = Global.pick_random(["right", "left"])
	liberating = 2.0
	if body:
		initial_pos = body.global_position
	
	await get_tree().create_timer(1.2).timeout
	Global.play_sound(Global.PrisonerReleasedSFX)
