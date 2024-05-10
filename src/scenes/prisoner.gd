extends CharacterBody2D
var gravity = 10.0
var speed = 125.0
var jump_speed = -300.0
@export var direction = "right"
var total_friction = 0.3
var friction = total_friction
var moving = false
var buff = 0
var in_air = false
var idle_time = 0
var tspeed = 370.0
var dead = false
var blowed = 0
const blood = preload("res://scenes/blood.tscn")

func _ready():
	add_to_group("players")
	$sprite.animation = "idle"
	
func is_on_floor_custom():
	return is_on_floor() or buff > 0

func _physics_process(delta):
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
	else:
		if friction != total_friction:
			friction = lerp(friction, total_friction, 0.01)
	if blowed <= 0:
		velocity.x = lerp(velocity.x, 0.0, friction)
	else:
		blowed -= 1 * delta
		
	process_player(delta)
	move_and_slide()

func process_player(delta):
	var moving = false
	if dead:
		set_collision_layer_value(2, true)
		set_collision_mask_value(2, true)
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
		
	#if !dead:
		#if !shoot_mode and Input.is_action_pressed("left"):
			#direction = "left"
			#moving = true
			#idle_time = 0
			#velocity.x = -speed
			#$sprite.flip_h = true
			#$gun_sprite.rotation = initial_rotation - 45
		#elif !shoot_mode and Input.is_action_pressed("right"):
			#direction = "right"
			#moving = true
			#idle_time = 0
			#velocity.x = speed
			#$sprite.flip_h = false
			#$gun_sprite.rotation = initial_rotation
	
	if !dead:
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
		$sprite.animation = "dead"
		
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
		blowed = 2
		Global.emit(global_position, 2)
		velocity = Global.flyaway(direction, jump_speed)

func bleed(count):
	for i in range(count):
		var blood_instance : Area2D = blood.instantiate()
		blood_instance.global_position = global_position
		get_parent().add_child(blood_instance)

func kill_fall():
	Global.main_camera.unregister_target(self)
	dead = true
	visible = false
	Global.find_master()
	queue_free()

func kill():
	Global.main_camera.unregister_target(self)
	dead = true
	Global.find_master()
	bleed(45)
	await get_tree().create_timer(2).timeout
	bleed(25)
