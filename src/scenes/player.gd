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
var gizmo = preload("res://scenes/gizmo.tscn")
var tspeed = 370.0
var initial_rotation = 0
var current_gizmo_instance = null 

func _ready():
	add_to_group("players")
	$sprite.animation = "idle"
	$gun_sprite.visible = false
	initial_rotation = $gun_sprite.rotation

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
		
	velocity.x = lerp(velocity.x, 0.0, friction)
	process_player(delta)
	move_and_slide()

func process_player(delta):
	var moving = false
	if Input.is_action_just_pressed("use"):
		do_action(delta)
	
	if Input.is_action_pressed("shoot"):
		shoot_mode = true
		$gun_sprite.visible = true
	
	if shoot_mode and Input.is_action_just_released("shoot"):
		shoot_mode = false
		shoot(delta)
		await get_tree().create_timer(0.3).timeout
		$gun_sprite.visible = false
		$gun_sprite.rotation = initial_rotation
		
	if shoot_mode:
		if Input.is_action_pressed("left"):
			$gun_sprite.rotation -= 1 * delta
		elif Input.is_action_pressed("right"):
			$gun_sprite.rotation += 1 * delta
	
	if Input.is_action_just_pressed("jump"):
		jump(delta)
		
	if !shoot_mode and Input.is_action_pressed("left"):
		direction = "left"
		moving = true
		idle_time = 0
		velocity.x = -speed
		$sprite.scale.x = -1
	elif !shoot_mode and Input.is_action_pressed("right"):
		direction = "right"
		moving = true
		idle_time = 0
		velocity.x = speed
		$sprite.scale.x = 1
		
	if moving:
		if $sprite.animation == "idle":
			$sprite.animation = "walking"
		$sprite.play()
	else:
		$sprite.stop()
		idle_time += 1 * delta
		if idle_time >= 0.3:  
			$sprite.animation = "idle"
		
func shoot(delta):
	var pos = $gun_sprite/mark.global_position
	var p = gizmo.instantiate()
	current_gizmo_instance = p
	get_parent().add_child(p)
	p.global_position = pos
	Global.emit(pos, 5)
	p.droped(Vector2.from_angle($gun_sprite.rotation) * tspeed)
	
func jump(delta):
	if is_on_floor_custom():
		buff = 0
		Global.play_sound(Global.JUMP_SFX)
		Global.emit(global_position, 2)
		velocity.y = jump_speed

func do_action(delta):
	if current_gizmo_instance != null:
		current_gizmo_instance.do_action(self)
