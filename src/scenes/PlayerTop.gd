extends Area2D
var rolling = 0.0
var moving = false
var speed = 215.0
var ttl_drop = 0.0
var rainobj = preload("res://scenes/Rain.tscn")
var waterdrop = preload("res://scenes/water_drp.tscn")
var rain = null
var dead = false
var dead_animation = ""
var has_gun = false
var real_direction = "right"
var direction = "right"
var shoot_ttl = 0.0
var shoot_ttl_total = 0.8
const BulletTopDown = preload("res://scenes/BulletTopDown.tscn")

func _ready():
	add_to_group("players")
	Global.player_obj = self
	Global.Fader.fade_out()
	rain = rainobj.instantiate()
	rain.manual_thunders = true
	rain.position = Vector2(-431, -267) 
	add_child(rain)
	
func get_gun():
	has_gun = true

func create_drop(pos):
	if ttl_drop <= 0:
		ttl_drop = 0.5
		var drop = waterdrop.instantiate()
		drop.position = Vector2(pos.x, pos.y + 16)
		get_parent().add_child(drop)
		
func shoot():
	if has_gun and shoot_ttl <= 0:
		shoot_ttl = shoot_ttl_total
		var pos = Vector2.ZERO
		if direction == "right":
			pos = $Gun_R/shoot_point.global_position
		else:
			pos = $Gun_L/shoot_point.global_position
			
		var p = BulletTopDown.instantiate()
		var parent = get_parent()
		p.global_position = pos
		p.direction = direction
		parent.add_child(p)
		Global.emit(pos, 5)
		Global.shaker_obj.shake(2.2, 0.5)
		
func force_thunder():
	rain.force_thunder()
	
func kill_fire():
	if rolling <= 0.0:
		Global.play_sound(Global.LavaFallSFX)
		Global.emit(global_position, 10)
		dead = true
		dead_animation = "dead_fire"

func _physics_process(delta):
	if shoot_ttl > 0:
		shoot_ttl -= 1 * delta
	
	if dead:
		Global.GAMEOVER = dead
		if Global.GAMEOVER:
			Global.OverWorldFromGameOver = true
		
		$sprite.animation = dead_animation
		$sprite_eyes.animation = $sprite.animation
		$PlayerReflect/sprite.animation = $sprite.animation
		$PlayerReflect/sprite_eyes.animation = $sprite_eyes.animation
		
		$Gun_R.visible = false
		$Gun_L.visible = false
		$PlayerReflect/Gun_R.visible = $Gun_R.visible
		$PlayerReflect/Gun_L.visible = $Gun_L.visible
		
	else:
		var shoot_action = false 
		if has_gun and rolling <= 0:
			shoot_action = Input.is_action_pressed("shoot")
		
		moving = false
		ttl_drop -= 1 * delta
		if Input.is_action_pressed("left") and rolling <= 0:
			real_direction = "left"
			if !shoot_action:
				direction = "left"
				$sprite.scale.x = -1
			create_drop(global_position)
			moving = true
			if position.x > 22:
				position.x -= speed * delta
		elif Input.is_action_pressed("right") and rolling <= 0:
			real_direction = "right"
			if !shoot_action:
				direction = "right"
				$sprite.scale.x = 1
			create_drop(global_position)
			moving = true
			if position.x < 1131:
				position.x += speed * delta
		elif Input.is_action_pressed("up") and rolling <= 0:
			real_direction = "up"
			create_drop(global_position)
			moving = true
			if position.y > 22:
				position.y -= speed * delta
		elif Input.is_action_pressed("down") and rolling <= 0:
			real_direction = "down"
			create_drop(global_position)
			moving = true
			if position.y < 621:
				position.y += speed * delta
				
		if rolling > 0:
			if real_direction == "left":
				if position.x > 22:
					position.x -= speed * 2 * delta
				else:
					rolling = 0
			elif real_direction == "right":
				if position.x < 1131:
					position.x += speed * 2 * delta
				else:
					rolling = 0
			elif real_direction == "up":
				if position.y > 22:
					position.y -= speed * 2 * delta
				else:
					rolling = 0
			elif real_direction == "down":
				if position.y < 621:
					position.y += speed * 2 * delta
				else:
					rolling = 0
			
			$sprite.rotation_degrees += (350 * $sprite.scale.x) * delta
			rolling -= 1 * delta
			$sprite.animation = "roll"
			$sprite_eyes.animation = $sprite.animation
			$sprite_eyes.rotation_degrees = $sprite.rotation_degrees
			$Gun_R.visible = false
			$Gun_L.visible = false
			if rolling <= 0:
				$sprite.rotation_degrees = 0
				$sprite_eyes.rotation_degrees = $sprite.rotation_degrees
				rolling = 0
				$sprite.animation = "idle"
				$sprite_eyes.animation = $sprite.animation
				
		if Input.is_action_just_pressed("jump") and rolling <= 0:
			rolling = 0.4
			shoot_ttl = 0.0
			
		if has_gun and rolling <= 0:
			if direction == "right":
				$Gun_R.visible = true
				$Gun_L.visible = false
			else:
				$Gun_R.visible = false
				$Gun_L.visible = true
				
			if shoot_action:
				shoot()
			
		$PlayerReflect/Gun_R.visible = $Gun_R.visible
		$PlayerReflect/Gun_L.visible = $Gun_L.visible
			
		if rolling <= 0:
			if moving:
				$sprite.play()
				$sprite_eyes.play()
				$sprite.animation = "walking"
				$sprite_eyes.animation = $sprite.animation
			else:
				$sprite.play()
				$sprite_eyes.play()
				$sprite.animation = "idle"
				$sprite_eyes.animation = $sprite.animation
			
		$sprite_eyes.scale.x = $sprite.scale.x
		$PlayerReflect/sprite.scale.x = $sprite.scale.x
		$PlayerReflect/sprite_eyes.scale.x = $sprite.scale.x
		
		$PlayerReflect/sprite.rotation_degrees = $sprite.rotation_degrees
		$PlayerReflect/sprite_eyes.rotation_degrees = $sprite.rotation_degrees
		
		$PlayerReflect/sprite.animation = $sprite.animation
		$PlayerReflect/sprite_eyes.animation = $sprite_eyes.animation
		$PlayerReflect/sprite.play()
		$PlayerReflect/sprite_eyes.play()
