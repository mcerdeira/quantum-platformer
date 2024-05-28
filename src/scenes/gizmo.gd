extends CharacterBody2D
var gravity = 1000.0
var jump_speed = -300.0
var grabbed = false
var total_friction = 0.6
var friction = total_friction
var landed = false
var simulation = false
var ttl = 0.5
var player_clone = load("res://scenes/player.tscn")
var spring_obj = load("res://scenes/spring.tscn")
var noise_time = 0
var explosion_delay = 0
var blowed = 0
var parent = null
var parent_lbl = null
var current_item = null
var action_executed = false
var count_down = 0

func _ready():
	add_to_group("interactuable")
	add_to_group("gizmos")
	
func is_on_floor_custom(normal):
	return (normal == Vector2.UP)
		
func _physics_process(delta):
	if !action_executed:
		$sprite.material.set_shader_parameter("crisis", false)
		velocity.y += gravity * delta
		var collision = move_and_collide(velocity * delta)
		if collision: 
			var normal = collision.get_normal()
			velocity = velocity.bounce(normal) * Global.bounce_amount
			if is_on_floor_custom(normal):
				if !landed:
					if !action_executed:
						if current_item.has_action:
							count_down = 3
							$lbl_count.visible = true
						
					noise_time = 0.3
					$AnimationPlayer2.play("new_animation")
					Global.emit(global_position, 1)
					$noise/collider.set_deferred("disabled", false)
					
				landed = true 
				
			if !landed:
				rotation += 5 * delta
			else:
				if current_item.has_action:
					if count_down > 0:
						count_down -= 1 * delta
						$lbl_count.text = str(round(count_down)) + "..."
						if count_down < 2:
							var a : AnimationPlayer = $AnimationPlayer
							if !a.is_playing():
								a.play("shak_")
								a.speed_scale += 100 * delta
						
						if count_down <= 0:
							do_action(parent, parent_lbl)
				else:
					do_action(parent, parent_lbl)
				
				if noise_time > 0:
					noise_time -= 1 * delta
					if noise_time <= 0:
						$noise/collider.set_deferred("disabled", true)
				
				rotation = 0
				if blowed > 0:
					blowed -= 1 * delta
				else:
					pass
					if !is_on_floor():
						velocity.x = lerp(velocity.x, 0.0, friction / 10)
					else:
						velocity.x = lerp(velocity.x, 0.0, friction)
					
	if explosion_delay > 0:
		explosion_delay -= 1 * delta
		if explosion_delay <= 0:
			queue_free()
		
func droped(_parent, _parent_lbl, direction, _current_item, _simulation = false):
	parent_lbl = _parent_lbl
	parent = _parent
	velocity = direction
	friction = 0.1
	simulation = _simulation
	current_item = _current_item
	if current_item.full_scale:
		$sprite.scale.x = 1
		$sprite.scale.y = 1

	if simulation:
		$sprite.visible = false
		set_collision_layer_value(2, true)
		set_collision_mask_value(2, true)
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
		$area.set_collision_layer_value(2, true)
		$area.set_collision_mask_value(2, true)
		$area.set_collision_layer_value(1, false)
		$area.set_collision_mask_value(1, false)
		$sprite.animation = "simul"
		modulate.a = 0.5
	else:
		$sprite.animation = Global.gunz_equiped[Global.gunz_index].name
		$Line2D.visible = false
		$Line2D.queue_free()
	
func do_action(_player, lbl):
	if !simulation and !action_executed:
		if true or landed:
			if current_item.has_action:
				action_executed = true
				lbl.visible = true
				lbl.text =  current_item.name.to_upper() + "!"
				
			if current_item.name == "teleport":
				Global.emit(_player.global_position, 10)
				action_executed = true
				_player.visible = false
				_player.global_position = $mark.global_position
				Global.emit(_player.global_position, 10)
			elif current_item.name == "clone":
				action_executed = true
				var pclone = player_clone.instantiate()
				pclone.global_position = $mark.global_position
				pclone.iam_clone = true
				get_parent().add_child(pclone)
				Global.emit(pclone.global_position, 10)
				queue_free()
			elif current_item.name == "bomb":
				action_executed = true
				explode()
			elif current_item.name == "spring":
				action_executed = true
				create_spring_object()
				queue_free()
				
			if current_item.has_action:
				_player.visible = true
				_player.lbl_hide_delegate(false, 1)
			
func create_spring_object():
	var spring_o = spring_obj.instantiate()
	spring_o.global_position = $mark.global_position - Vector2(0, 3)
	get_parent().add_child(spring_o)
	Global.emit(global_position, 10)
	
func explode():
	if !simulation:
		$sprite.visible = false
		$explosion/collider.set_deferred("disabled", false)
		$explosion_mini/collider.set_deferred("disabled", false)
		$explosion_mini/collider2.set_deferred("disabled", false)
		$explosion_mini/collider3.set_deferred("disabled", false)
		
		explosion_delay = 1.2
		$explosions.explode()

func _on_area_body_entered(body):
	if !simulation:
		if body and body.is_in_group("enemies"):
			body.still_alert()
			Global.emit(global_position, 1)
			queue_free()
	
		if body and body.is_in_group("players"):
			Global.emit(global_position, 1)
			Global.get_item(current_item)
			queue_free()

func _on_noise_body_entered(body):
	if !simulation:
		if body and body.is_in_group("enemies"):
			body.hearing_alerted(self)

func flyaway(direction):
	if blowed <= 0:
		blowed = 2
		Global.emit(global_position, 2)
		velocity = Global.flyaway(direction, jump_speed)

func kill_fall():
	visible = false
	queue_free()

func super_jump():
	Global.play_sound(Global.JUMP_SFX)
	Global.emit(global_position, 2)
	velocity.y = jump_speed * 2

func set_red_color(val):
	$sprite.material.set_shader_parameter("crisis", val)
