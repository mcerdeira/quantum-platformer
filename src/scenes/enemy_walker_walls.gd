extends CharacterBody2D
var gravity = 10.0
var total_speed = 60.0
var speed = total_speed
var jump_speed = -300.0
@export var direction = "right"
var total_friction = 0.6
var friction = total_friction
var moving = false
var buff = 0
var in_air = false
var idle_time = 0
var tspeed = 370.0
var initial_rotation = 0
var total_killing = 6
var killing = 0
var direction_change_ttl_total = 1
var direction_change_ttl = direction_change_ttl_total
var blowed = 0
var previus_velocity = Vector2.ZERO
var fire_obj = null
var level_parent = null
var dead_frames = 5
var delay_change_total = 0.5
var delay_change = 0
var dead = false
var replace_me = preload("res://scenes/enemy_walker.tscn")

var destination_rotation = 0
var destination_position = Vector2.ZERO
var tween = null

var fires = preload("res://scenes/Fires.tscn")
enum States {
	RIGHT,
	LEFT,
	UP,
	DOWN,
}

var state = States.RIGHT

func _ready():
	add_to_group("enemies")
	$sprite.animation = "idle"
	
func is_on_floor_custom():
	return is_on_floor() or buff > 0
	
func _physics_process(delta):
	speed = total_speed
	
	if blowed > 0:
		if is_on_floor():
			if in_air:
				in_air = false
				Global.emit(global_position, 1)
			buff = 0.2
		else:
			in_air = true
			buff -= 1 * delta
			
		if fire_obj and is_instance_valid(fire_obj):
			fire_obj.reparent(level_parent)
			fire_obj.global_position = global_position
			fire_obj.z_index = z_index + 1
		
		if !is_on_floor_custom():
			velocity.y += gravity
		
		if blowed > 0:
			blowed -= 1 * delta
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
	else:
		if state == States.RIGHT:
			velocity.y += gravity
		if state == States.LEFT:
			velocity.y -= gravity
		if state == States.UP:
			velocity.x += gravity
		if state == States.DOWN:
			velocity.x -= gravity

	process_player(delta)
	move_and_slide()
	
func detection_ok(col):
	return (col and col is TileMap)
	
func reset_delay():
	tween = null
	delay_change = 0
	
func process_player(delta):
	var moving = false
	if blowed > 0:
		$sprite.animation = "stunned"
		$stars_stunned.visible = true
		return
		
	if Global.GAMEOVER:
		pass
		
	if dead:
		$sprite/eyes.animation = $sprite.animation
		$sprite/eyes.flip_h = $sprite.flip_h 
		$AnimationPlayer.stop()
		$stars_stunned.visible = false
		return
				
	if killing > 0:
		velocity = Vector2.ZERO
		killing -= 1 * delta 
		if $sprite.animation != "killing":
			$AnimationPlayer.play("killing")
			$sprite.animation = "killing"
			$sprite/eyes.animation = "killing"
			$sprite.play()
			$sprite/eyes.play()
		
		if killing <= 0:
			$AnimationPlayer.stop()
			$sprite.animation = "idle"
			killing = 0
	else:
		if dead_frames <= 0: 
			var ray_floor : RayCast2D = $ray_floor
			var ray_wall : RayCast2D = $ray_wall
			
			var col_floor = ray_floor.get_collider()
			var col_wall = ray_wall.get_collider()
			
			if delay_change > 0:
				if !tween:
					tween = get_tree().create_tween()
					tween.tween_property(self, "rotation_degrees", destination_rotation, delay_change_total)
					tween.tween_property(self, "position", destination_position, delay_change_total)
					
					tween.tween_callback(reset_delay)
				
			else:	
				if state == States.RIGHT:
					if is_on_floor() and is_on_wall() and detection_ok(col_floor) and detection_ok(col_wall):
						moving = false
						delay_change = delay_change_total
						velocity = Vector2.ZERO
						destination_rotation = rotation_degrees - 90
						destination_position = Vector2(position.x + 32, position.y)

						state = States.UP
						
					elif !is_on_floor() and !is_on_wall() and !detection_ok(col_floor) and !detection_ok(col_wall):
						moving = false
						delay_change = delay_change_total
						velocity = Vector2.ZERO
						destination_rotation = rotation_degrees + 90
						destination_position = null
						state = States.DOWN
						
					else:	
						velocity.x = speed
						moving = true
				
				elif state == States.UP:
					if is_on_wall() and is_on_ceiling() and detection_ok(col_wall) and detection_ok(col_floor):
						moving = false
						delay_change = delay_change_total
						velocity = Vector2.ZERO
						
						destination_rotation = rotation_degrees - 90
						destination_position = Vector2(position.x, position.y - 32)
						
						state = States.LEFT
						
					elif !is_on_wall() and !is_on_ceiling() and !detection_ok(col_wall) and !detection_ok(col_floor):
						moving = false
						delay_change = delay_change_total
						velocity = Vector2.ZERO
						destination_rotation = rotation_degrees + 90
						destination_position = null
						state = States.RIGHT
					else:	
						velocity.y = -speed
						moving = true
						
				elif state == States.DOWN:
					if is_on_wall() and is_on_floor() and detection_ok(col_wall) and detection_ok(col_floor):
						moving = false
						delay_change = delay_change_total
						velocity = Vector2.ZERO
						destination_rotation = rotation_degrees - 90
						destination_position = Vector2(position.x, position.y + 32)
						state = States.RIGHT
						
					elif !is_on_floor() and !is_on_wall() and !detection_ok(col_wall) and !detection_ok(col_floor):
						moving = false
						delay_change = delay_change_total
						velocity = Vector2.ZERO
						
						destination_rotation = rotation_degrees + 90
						destination_position = null
						
						state = States.LEFT
					else:	
						velocity.y = speed
						moving = true
						
				elif state == States.LEFT:
					if is_on_ceiling() and is_on_wall() and detection_ok(col_floor) and detection_ok(col_wall):
						moving = false
						delay_change = delay_change_total
						velocity = Vector2.ZERO
						
						destination_rotation = rotation_degrees - 90
						destination_position = Vector2(position.x - 32, position.y)
						state = States.DOWN
						
					elif !is_on_ceiling() and !is_on_wall() and !detection_ok(col_floor) and !detection_ok(col_wall):
						moving = false
						delay_change = delay_change_total
						velocity = Vector2.ZERO
						
						destination_rotation = rotation_degrees + 90
						destination_position = null
						
						state = States.UP
					else:	
						velocity.x = -speed
						moving = true
				
		if dead_frames > 0:
			if is_on_floor():
				dead_frames -= 1

	if killing <= 0:
		if moving:
			if $sprite.animation == "idle":
				$sprite.animation = "walking"
			$sprite.play()
			$sprite/eyes.play()
		else:
			$sprite.stop()
			$sprite/eyes.stop()
			idle_time += 1 * delta
			if idle_time >= 0.3:  
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

func kill_fire():
	if fire_obj == null or !is_instance_valid(fire_obj):
		Global.emit(global_position, 10)	
		var parent = level_parent
		var p = fires.instantiate()
		p.global_position = global_position
		p.kill_me = self
		parent.add_child(p)
		fire_obj = p

func dead_fire():
	dead = true
	$sprite.animation = "dead_fire"
	$sprite.play()
	set_collision_layer_value(5, true)
	set_collision_mask_value(5, true)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
func hearing_alerted(body):
	pass
	
func kill_fall():
	visible = false
	queue_free()
	
func eat_gizmo(current_item):
	killing = total_killing

func flyaway(direction):
	if blowed <= 0:
		queue_free()
		visible = false
		var parent = get_parent()
		var p = replace_me.instantiate()
		p.spr_sufix = "_wall"
		p.global_position = global_position
		parent.add_child(p)
		p.flyaway(direction)

func super_jump():
	Global.emit(global_position, 2)
	velocity.y = jump_speed * 2
