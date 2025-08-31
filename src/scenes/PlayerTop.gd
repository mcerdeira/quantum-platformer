extends Area2D
var rolling = 0.0
var moving = false
var speed = 215.0
var ttl_drop = 0.0
var rainobj = preload("res://scenes/Rain.tscn")
var waterdrop = preload("res://scenes/water_drp.tscn")
var watersplash = preload("res://scenes/Confeti.tscn")
const blood = preload("res://scenes/blood.tscn")
var locked_ctrls = false
var rain = null
var dead = false
var dead_animation = ""
var has_gun = false
var real_direction = "right"
var direction = "right"
var shoot_ttl = 0.0
var shoot_ttl_total = 0.7
const BulletTopDown = preload("res://scenes/BulletTopDown.tscn")
var itemfound = preload("res://scenes/Item3D.tscn")
var gosplash = false
var splash_ttl_total = 0.1
var splash_ttl = 0
var goup = false
var explodeloop = null
@export var water : Node2D

func _ready():
	add_to_group("players")
	Global.player_obj = self
	Global.Fader.fade_out()
	rain = rainobj.instantiate()
	rain.manual_thunders = true
	rain.position = Vector2(-431, -267) 
	add_child(rain)
	
func splash():
	var count = randi_range(1, 2)
	for i in range(count):
		var sp = watersplash.instantiate()
		var aju = randi_range(0, 10) * Global.pick_random([1. -1])
		sp.global_position = Vector2(global_position.x + aju, global_position.y + 16)
		get_parent().add_child(sp)
	
func get_gun():
	has_gun = true

func create_drop(pos):
	if ttl_drop <= 0:
		ttl_drop = 0.5
		var drop = waterdrop.instantiate()
		drop.position = Vector2(pos.x, pos.y + 16)
		get_parent().add_child(drop)
		
func killeat():
	dead = true
	visible = false
	Global.play_sound(Global.PlayerBleedSFX)
	await get_tree().create_timer(0.9).timeout
	bleed(50)
	
func show_message_bonus():
	pass
	
func show_message_death():
	pass
		
func bleed(count):
	Global.play_sound(Global.PlayerBleedSFX)
	for i in range(count):
		var blood_instance : Area2D = blood.instantiate()
		blood_instance.global_position = global_position
		#get_parent().add_child(blood_instance)
		get_parent().call_deferred("add_child", blood_instance)
		
func shoot():
	if has_gun and shoot_ttl <= 0:
		Global.play_sound(Global.ShotGunSFX)
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
		Global.emit(pos, 25)
		Global.shaker_obj.shake(3.2, 0.5)
		
func force_thunder():
	rain.force_thunder()
	
func kill_fire():
	if rolling <= 0.0:
		Global.play_sound(Global.LavaFallSFX)
		Global.emit(global_position, 10)
		dead = true
		dead_animation = "dead_fire"
		
func show_message():
	$display.visible = true
	$display/back/lbl_item.text = "¿Y ahora... QUE?"
	
func hide_message():
	$display.visible = false
	var p = itemfound.instantiate()
	p.global_position = Vector2(548, 329)
	get_parent().add_child(p)
	gosplash = true
	$Timer.start()

func _physics_process(delta):
	if gosplash:
		if !explodeloop:
			explodeloop = Global.play_sound(Global.ExplodeLoopSFX)
		if goup:
			position.y -= (speed * 2) * delta
		Global.shaker_obj.shake(10, 1.1)
		if goup:
			splash_ttl -= 1 * delta
			if splash_ttl <= 0:
				splash_ttl = splash_ttl_total
				splash()
	
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
		if has_gun and rolling <= 0 and !locked_ctrls:
			shoot_action = Input.is_action_pressed("shoot")
		
		moving = false
		ttl_drop -= 1 * delta
		if Input.is_action_pressed("left") and rolling <= 0 and !locked_ctrls:
			real_direction = "left"
			if !shoot_action:
				direction = "left"
				$sprite.scale.x = -1
			create_drop(global_position)
			moving = true
			if position.x > 22 + 32:
				position.x -= speed * delta
		elif Input.is_action_pressed("right") and rolling <= 0 and !locked_ctrls:
			real_direction = "right"
			if !shoot_action:
				direction = "right"
				$sprite.scale.x = 1
			create_drop(global_position)
			moving = true
			if position.x < 1131 - 32:
				position.x += speed * delta
		if Input.is_action_pressed("up") and rolling <= 0 and !locked_ctrls:
			real_direction = "up"
			create_drop(global_position)
			moving = true
			if position.y > 22 + 32:
				position.y -= speed * delta
		elif Input.is_action_pressed("down") and rolling <= 0 and !locked_ctrls:
			real_direction = "down"
			create_drop(global_position)
			moving = true
			if position.y < 621 - 32:
				position.y += speed * delta
				
		if rolling > 0:
			if real_direction == "left":
				if position.x > 22 + 32:
					position.x -= speed * 2 * delta
				else:
					rolling = 0
			elif real_direction == "right":
				if position.x < 1131 - 32:
					position.x += speed * 2 * delta
				else:
					rolling = 0
			elif real_direction == "up":
				if position.y > 22 + 32:
					position.y -= speed * 2 * delta
				else:
					rolling = 0
			elif real_direction == "down":
				if position.y < 621 - 32:
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
			Global.play_sound(Global.RollingSFX)
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


func _on_timer_timeout() -> void:
	if !goup:
		water.global_position = global_position
		water.do_start()
		goup = true
		explodeloop.stop()
		Global.play_sound(Global.ExplosionsndSXF)
	else:
		Global.scene_next(Global.TerminalNumber, false, false, false, true)
