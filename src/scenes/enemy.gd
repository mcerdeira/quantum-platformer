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
var initial_rotation = 0
var hostile = false

func _ready():
	add_to_group("enemies")
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
		
	velocity.x = lerp(velocity.x, 0.0, friction)
	process_player(delta)
	move_and_slide()

func process_player(delta):
	var moving = false
					
	if Input.is_action_just_pressed("jump"):
		jump(delta)
		
	if !hostile:
		pass
	else:
		if Input.is_action_pressed("left"):
			direction = "left"
			moving = true
			idle_time = 0
			velocity.x = -speed
			$sprite.scale.x = -1
		elif Input.is_action_pressed("right"):
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
		
func jump(delta):
	if is_on_floor_custom():
		buff = 0
		Global.play_sound(Global.JUMP_SFX)
		Global.emit(global_position, 2)
		velocity.y = jump_speed

