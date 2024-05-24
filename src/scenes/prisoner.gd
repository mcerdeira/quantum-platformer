extends CharacterBody2D
var gravity = 10.0
var speed = 125.0
var jump_speed = -300.0
@export var direction = "right"
var total_friction = 0.3
var im_invisible = false
var friction = total_friction
var moving = false
var buff = 0
var in_air = false
var idle_time = 0
var tspeed = 370.0
var dead = false
var blowed = 0
const blood = preload("res://scenes/blood.tscn")
var previus_velocity = Vector2.ZERO
var trapped = true
var dir = 1
var liberating = 0
var help_messages = ["HELP!", "SAVE ME!", "S.O.S"]
var thanks_messages = ["THANKS!", "MY HERO!"]
var thanks_message = Global.pick_random(thanks_messages)
var is_on_stairs = false
var grabbed = false

func _ready():
	add_to_group("players")
	add_to_group("prisoners")
	$sprite.animation = "trapped"
	$sprite.play()
	$lbl_action.text = Global.pick_random(help_messages)
	
func is_on_floor_custom():
	return is_on_floor() or buff > 0

func _physics_process(delta):
	if trapped:
		if liberating > 0:
			$lbl_action.text = thanks_message
			liberating -= 1 * delta
			if liberating <= 0:
				Global.prisoner_counter -= 1
				$trapped_area.queue_free()
				$collider.set_deferred("disabled", false)
				trapped = false
				$lbl_action.text = ""
				$lbl_action.visible = false
	else:
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

		if blowed > 0:
			blowed -= 1 * delta
			if is_on_wall():
				velocity.x = (previus_velocity.x / 2) * -1
			else:
				previus_velocity = velocity
		else:
			if !is_on_floor_custom():
				velocity.x = lerp(velocity.x, 0.0, friction / 10)
			else:
				velocity.x = lerp(velocity.x, 0.0, friction)
			
		process_player(delta)
		move_and_slide()

func process_player(delta):
	var moving = false
	if dead:
		set_collision_layer_value(5, true)
		set_collision_mask_value(5, true)
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
	if !dead:
		if blowed > 0:
			$lbl_action.visible = true
			$lbl_action.text = "@"
			$lbl_action.set("theme_override_colors/font_color", Color.AQUAMARINE)
			blowed -= 1 * delta
			if blowed <= 0:
				$lbl_action.visible = false
			return
		
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
	Global.find_master()
	queue_free()

func kill():
	dead = true
	Global.find_master()
	bleed(45)
	await get_tree().create_timer(2).timeout
	bleed(25)

func super_jump():
	if !dead:
		buff = 0
		Global.play_sound(Global.JUMP_SFX)
		Global.emit(global_position, 2)
		velocity.y = jump_speed * 2

func _on_trapped_area_body_entered(body):
	if body.is_in_group("players"):
		liberating = 1.4
