extends CharacterBody2D
var active = false
var gravity = 6.0
var total_speed = 60.0
var speed = total_speed
var jump_speed = -550.0
@export var direction = ""
var total_friction = 0.6
var friction = total_friction
var moving = false
var buff = 0
var in_air = false
var idle_time = 0
var tspeed = 370.0
var initial_rotation = 0
var direction_change_ttl_total = 1
var direction_change_ttl = direction_change_ttl_total
var blowed = 0
var previus_velocity = Vector2.ZERO
var level_parent = null
var dead = false
var TOTAL_LIFE = 5.0
var LIFE = TOTAL_LIFE
var explode_ttl = 3
var prisoner_obj = preload("res://scenes/prisoner.tscn")

func _ready():
	Global.BOSS_DEAD = false
	add_to_group("enemies")
	add_to_group("bosses")
	$sprite.animation = "idle"
	z_index = 100
	Global.gotoBOSS = true
	
func is_on_floor_custom():
	return is_on_floor() or buff > 0
	
func activate():
	Music.play(Global.BossTheme)
	direction = Global.pick_random(["right", "left"])
	visible = true
	active = true
	$"../BossSpawn".visible = false
	$"../BossSpawn".queue_free()
	Global.boss_bar.showme("BICHO FEO")
	
func _physics_process(delta):
	if !active:
		return
		
	speed = total_speed
	if is_on_floor() and !dead:
		if in_air:
			in_air = false
			$sprite.scale.y = 0.5
			var options = {"pitch_scale": 0.5}
			Global.play_sound(Global.BigExplodeRetroSFX, options)
			Global.emit(global_position, 30)
			Global.shaker_obj.shake(10, 0.5)
			jump()
		buff = 0.2
	else:
		in_air = true
		buff -= 1 * delta
		
	if $sprite.scale.y != 1:
		$sprite.scale.y = lerp($sprite.scale.y, 1.3, 0.04)
	
	if !is_on_floor_custom():
		velocity.y += gravity
	
	if blowed > 0:
		blowed -= 1 * delta
		velocity.x = lerp(velocity.x, 0.0, 1)
		$sprite.scale.y = 1
		if is_on_wall():
			velocity.x = (previus_velocity.x / 2) * -1
		else:
			previus_velocity = velocity
		
		if blowed <= 0:
			$sprite.animation = "idle"
			jump()
	else:
		$stars_stunned.visible = false
		if !is_on_floor_custom():
			velocity.x = lerp(velocity.x, 0.0, friction / 10)
		else:
			velocity.x = lerp(velocity.x, 0.0, friction)

	process_player(delta)
	move_and_slide()	
	
func process_player(delta):
	if !active:
		return
	
	moving = false
	
	if blowed > 0 and !dead:
		$stars_stunned.visible = true
		$sprite.animation = "stunned"
		return
		
	if dead:
		#Global.player_obj.show_message_demo()
		Global.LEAF_STATUS = false
		Global.TOMB_STATUS = true
		
		$sprite.scale.y = 1
		$stars_stunned.visible = false
		$sprite.animation = "stunned"
		explode_ttl -= 1 * delta
		
		if explode_ttl <= 0 and $sprite.visible:
			Global.shaker_obj.shake(12, 1.2)
			$BossExplosionShader.start()
			$sprite.visible = false
			var pri = prisoner_obj.instantiate()
			pri.global_position = global_position
			get_parent().add_child(pri)
			pri.convert_into_npc()
			$explosions.stop()
			$collider.set_deferred("disabled", true)	
			Music.play(Global.ShopTheme)
			Global.FromPipe = true
			Ambience.stop()
			Global.player_obj.restart_camera($"../CameraZoomer")
		return

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
						
func set_flip(flip):
	$sprite.flip_h = flip

func jump():
	if !dead and is_on_floor_custom() and blowed <= 0:
		buff = 0
		var options = {"pitch_scale": 0.2 }
		Global.play_sound(Global.Boss1JumpSFX, options)
		Global.emit(global_position, 2)
		velocity.y = jump_speed

func _on_area_body_entered(body):
	if !dead and blowed <= 0:
		if body and body.is_in_group("players"):
			body.kill()
			$Area/collider.set_deferred("disabled", true)
			
func kill_fire(tt_total = null):
	pass

func dead_fire():
	pass
	
func hearing_alerted(_body):
	pass
	
func eat_gizmo(_current_item):
	pass
	
func kill_fall():
	visible = false
	queue_free()

func flyaway():
	if blowed <= 0:
		LIFE -= 1.0
		Global.play_sound(Global.BOSS1RoarSFX)
		if LIFE <= 0.0:
			force_kill()
			
		total_speed *= 1.8
		speed = total_speed
		Global.shaker_obj.shake(3, 0.5)
		Global.boss_bar.calc_life_bar(TOTAL_LIFE, LIFE)
		blowed = 6.2
		
func force_kill():
	$explosion.queue_free()
	$explosions.start()
	dead = true
	LIFE = 0.0
	explode_ttl = 3
	Global.ARTIFACT_PER_LEVEL[Global.TerminalNumber] = true
	Global.gotoBOSS = false
	Global.shaker_obj.shake(3, 0.5)
	Global.BOSS_DEAD = true
			
func super_jump():
	pass
