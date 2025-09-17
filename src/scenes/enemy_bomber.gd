extends CharacterBody2D
var gravity = 10.0
var total_speed = 60.0
var speed = total_speed
var jump_speed = -300.0
const gizmo = preload("res://scenes/gizmo.tscn")
@export var direction = "right"
var total_friction = 0.6
var friction = total_friction
var moving = false
var buff = 0
var in_air = false
var idle_time = 0
var tspeed = 700.0
var initial_rotation = 0
var total_killing = 6
var killing = 0
var direction_change_ttl_total = 1
var direction_change_ttl = direction_change_ttl_total
var blowed = 0
var previus_velocity = Vector2.ZERO
var fire_obj = null
var level_parent = null
var fires = preload("res://scenes/Fires.tscn")
var dead = false
var active = false
var shoot_ttl_total = 10.0
var shoot_ttl = 3.0
var blind = false

func _ready():
	add_to_group("enemies")
	$sprite.animation = "idle"
	
func is_on_floor_custom():
	return is_on_floor() or buff > 0
	
func shoot():
	if shoot_ttl <= 0:
		$arms.animation = "throw"
		$arms.play()
		$Bomb.visible = false
		shoot_ttl = shoot_ttl_total * Global.pick_random([1, 2, 3, 4])
		var pos = $BombMark.global_position
		var p = gizmo.instantiate()
		var parent = get_parent()
		p.global_position = pos
		parent.add_child(p)
		Global.emit(pos, 5)
		var _rotation = 0
		if direction == "right":
			_rotation = -45
		else:
			_rotation = 180
		
		tspeed = Global.pick_random([700.0, 800.0, 750.0])
		var current_item = Global.bomb
		p.droped(self, null, Vector2.from_angle(_rotation) * tspeed, current_item, false, true)

func _physics_process(delta):
	speed = total_speed
	if is_on_floor():
		if in_air:
			in_air = false
			Global.emit(global_position, 1)
		buff = 0.2
	else:
		in_air = true
		buff -= 1 * delta
		
	if fire_obj and is_instance_valid(fire_obj):
		var current = fire_obj.get_parent()
		if current:
			fire_obj.reparent(level_parent)
		else:
			level_parent.add_child(fire_obj)
		fire_obj.global_position = global_position
		fire_obj.z_index = z_index + 1
	
	if !is_on_floor_custom():
		velocity.y += gravity
	
	if blowed > 0:
		blowed -= 1 * delta
		if blowed <= 0:
			$lbl_status.visible = true
			$Bomb.visible = true
			$arms.visible = true
		
		if is_on_wall():
			velocity.x = (previus_velocity.x / 2) * -1
		else:
			previus_velocity = velocity
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
	if blowed > 0:
		$stars_stunned.visible = true
		$sprite.animation = "stunned"
		$sprite/eyes.animation = $sprite.animation
		$sprite/eyes.play()
		$arms.visible = false
		$Bomb.visible = false
		$lbl_status.visible = false
		return
		
	if Global.GAMEOVER:
		pass
		
	if dead:
		$sprite/eyes.animation = $sprite.animation
		$sprite/eyes.flip_h = $sprite.flip_h 
		$arms.visible = false
		$Bomb.visible = false
		$lbl_status.visible = false
		$AnimationPlayer.stop()
		$stars_stunned.visible = false
		return
		
				
	if killing > 0:
		killing -= 1 * delta 
		if $sprite.animation != "killing":
			$arms.visible = false
			$Bomb.visible = false
			$lbl_status.visible = false
			$AnimationPlayer.play("killing")
			$sprite.animation = "killing"
			$sprite/eyes.animation = "killing"
			$sprite.play()
			$sprite/eyes.play()
		
		if killing <= 0:
			$AnimationPlayer.stop()
			$sprite.animation = "idle"
			$arms.visible = true
			killing = 0
	else:
		$arms.visible = true
		$arms.flip_h = $sprite.flip_h
		
		if active:
			shoot_ttl -= 1 * delta
			shoot()
	
		if global_position.x > Global.player_obj.global_position.x:
			direction = "left"
		else:
			direction = "right"
	
		if direction == "right":
			idle_time = 0
			$sprite.flip_h = false
		else:
			idle_time = 0
			$sprite.flip_h = true
			
	if killing <= 0:
		if moving:
			if $sprite.animation != "walking":
				$sprite.animation = "walking"
			$sprite.play()
			$sprite/eyes.play()
		else:
			$sprite.stop()
			$sprite/eyes.stop()
			$sprite.animation = "idle"
		
		$sprite/eyes.animation = $sprite.animation
		$sprite/eyes.flip_h = $sprite.flip_h 

func jump(delta):
	if !Global.GAMEOVER:
		if is_on_floor_custom():
			buff = 0
			Global.play_sound(Global.EnemyJumpSFX, {}, global_position)
			Global.emit(global_position, 2)
			velocity.y = jump_speed

func _on_area_body_entered(body):
	if !dead and blowed <= 0: 
		if body and body.is_in_group("players"):
			Global.play_sound(Global.EnemyChewingSFX, {}, global_position)
			body.kill()
			killing = total_killing
			if global_position.x > body.global_position.x:
				$sprite.flip_h = true
			else:
				$sprite.flip_h = false

func kill_fire(tt_total = null):
	if fire_obj == null or !is_instance_valid(fire_obj):
		if level_parent:
			Global.emit(global_position, 10)
			var parent = level_parent
			var p = fires.instantiate()
			p.global_position = global_position
			p.kill_me = self
			#parent.add_child(p)
			parent.call_deferred("add_child", p)
			fire_obj = p

func dead_fire():
	if randi() % 2 == 0:
		$Item.visible = true
	dead = true
	$sprite.animation = "dead_fire"
	$sprite.play()
	set_collision_layer_value(5, true)
	set_collision_mask_value(5, true)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
func hearing_alerted(body):
	pass
	
func eat_gizmo(current_item):
	killing = total_killing
	
func kill_fall():
	visible = false
	queue_free()

func flyaway(direction):
	if blowed <= 0:
		blowed = 6.2
		Global.emit(global_position, 2)
		velocity = Global.flyaway(direction, jump_speed)
		previus_velocity = velocity

func super_jump():
	Global.emit(global_position, 2)
	velocity.y = jump_speed * 2


func _on_active_area_body_entered(body):
	if !dead:
		if body and body.is_in_group("players") and !body.is_in_group("prisoners"):
			active = true
			$lbl_status.visible = true
			$arms.animation = "default"
			$Bomb.visible = true

func _on_arms_animation_finished():
	if $arms.animation == "throw":
		$arms.animation = "default"
		$Bomb.visible = true
