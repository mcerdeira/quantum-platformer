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
var shoot_mode = false
const gizmo = preload("res://scenes/gizmo.tscn")
var tspeed = 370.0
var initial_rotation = 0
var current_gizmo_instance = null 
var gizmo_simul = null
var item_action = ""
var iam_clone = false
var dead = false
var blowed = 0
const blood = preload("res://scenes/blood.tscn")

func _ready():
	add_to_group("players")
	$sprite.animation = "idle"
	$gun_sprite.visible = false
	initial_rotation = $gun_sprite.rotation
	Global.main_camera.register_target(self)
	
func create_gizmo_simul():
	var pos = $gun_sprite/mark.global_position
	gizmo_simul = gizmo.instantiate()
	var parent = get_parent()
	parent.add_child(gizmo_simul)
	gizmo_simul.global_position = pos
	gizmo_simul.droped(Vector2.from_angle($gun_sprite.rotation) * tspeed, true)
	
func destroy_gizmo_simul():
	if gizmo_simul != null and is_instance_valid(gizmo_simul):
		gizmo_simul.visible = false
		gizmo_simul.queue_free()

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
	
	if Input.is_action_just_pressed("use"):
		do_action(delta)
		
	if !dead and !iam_clone:
		if Input.is_action_just_pressed("scroll"):
			if Global.gunz_index == 0:
				Global.gunz_index = 1
			elif Global.gunz_index == 1:
				Global.gunz_index = 0
			get_parent().calc_selected()
	
	if !dead and Input.is_action_pressed("shoot"):
		Global.time_speed = 0.1
		if gizmo_simul == null or !is_instance_valid(gizmo_simul):
			create_gizmo_simul()
		shoot_mode = true
		$gun_sprite.visible = true
	
	if shoot_mode and Input.is_action_just_released("shoot"):
		Global.time_speed = 1.0
		destroy_gizmo_simul()
		shoot_mode = false
		shoot(delta)
		await get_tree().create_timer(0.3).timeout
		$gun_sprite.visible = false
		$gun_sprite.rotation = initial_rotation
		
	if shoot_mode:
		if Input.is_action_pressed("left"):
			$gun_sprite.rotation -= 1 * delta
			destroy_gizmo_simul()
			create_gizmo_simul()
		elif Input.is_action_pressed("right"):
			$gun_sprite.rotation += 1 * delta
			destroy_gizmo_simul()
			create_gizmo_simul()
	
	if !dead and Input.is_action_just_pressed("jump"):
		jump(delta)
		
	if !dead:
		if !shoot_mode and Input.is_action_pressed("left"):
			direction = "left"
			moving = true
			idle_time = 0
			velocity.x = -speed
			$sprite.flip_h = true
		elif !shoot_mode and Input.is_action_pressed("right"):
			direction = "right"
			moving = true
			idle_time = 0
			velocity.x = speed
			$sprite.flip_h = false
	
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
		
func shoot(delta):
	if !dead:
		var pos = $gun_sprite/mark.global_position
		var p = gizmo.instantiate()
		current_gizmo_instance = p
		var parent = get_parent()
		parent.add_child(p)
		p.global_position = pos
		Global.emit(pos, 5)
		p.droped(Vector2.from_angle($gun_sprite.rotation) * tspeed)
	
func jump(delta):
	if !dead:
		if is_on_floor_custom():
			buff = 0
			Global.play_sound(Global.JUMP_SFX)
			Global.emit(global_position, 2)
			velocity.y = jump_speed

func do_action(delta):
	if !dead:
		if current_gizmo_instance != null:
			item_action = Global.gunz_equiped[Global.gunz_index]
			current_gizmo_instance.do_action(self, $lbl_action, item_action)
			current_gizmo_instance = null

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

func kill():
	dead = true
	bleed(45)
	await get_tree().create_timer(2).timeout
	bleed(25)
