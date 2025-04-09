extends Area2D
var moving = false
var speed = 100
var ttl_drop = 0.0
var rainobj = preload("res://scenes/Rain.tscn")
var waterdrop = preload("res://scenes/water_drp.tscn")
var rain = null
var dead = false
var dead_animation = ""
var has_gun = false
var direction = "right"
var shoot_ttl = 0.0
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
		shoot_ttl = 0.1
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
		moving = false
		ttl_drop -= 1 * delta
		if Input.is_action_pressed("left"):
			direction = "left"
			create_drop(global_position)
			moving = true
			position.x -= speed * delta
			$sprite.scale.x = -1
		elif Input.is_action_pressed("right"):
			direction = "right"
			create_drop(global_position)
			moving = true
			position.x += speed * delta
			$sprite.scale.x = 1
		elif Input.is_action_pressed("up"):
			create_drop(global_position)
			moving = true
			position.y -= speed * delta
		elif Input.is_action_pressed("down"):
			create_drop(global_position)
			moving = true
			position.y += speed * delta
			
		if has_gun:
			if direction == "right":
				$Gun_R.visible = true
				$Gun_L.visible = false
			else:
				$Gun_R.visible = false
				$Gun_L.visible = true
				
			if Input.is_action_pressed("shoot"):
				shoot()
			
		$PlayerReflect/Gun_R.visible = $Gun_R.visible
		$PlayerReflect/Gun_L.visible = $Gun_L.visible
			
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
		
		$PlayerReflect/sprite.animation = $sprite.animation
		$PlayerReflect/sprite_eyes.animation = $sprite_eyes.animation
		$PlayerReflect/sprite.play()
		$PlayerReflect/sprite_eyes.play()
	
