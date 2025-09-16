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
var plant_obj = load("res://scenes/plant_obj.tscn")
var smoke_obj = load("res://scenes/smoke_obj.tscn")
var noise_time = 0
var explosion_delay = 0
var blowed = 0
var parent = null
var parent_lbl = null
var current_item = null
var action_executed = false
var count_down = 0
var attach_to = null
var gizmo_mode = false
var from_enemy = false

func _ready():
	add_to_group("interactuable")
	add_to_group("gizmos")
	
func is_on_floor_custom(normal):
	return (normal == Vector2.UP)
		
func _physics_process(delta):
	if !action_executed:
		$sprite.material.set_shader_parameter("crisis", false)
		velocity.y += gravity * delta
		
		if attach_to != null:
			velocity = Vector2.ZERO
		
		var collision = move_and_collide(velocity * delta)
		if collision or attach_to:
			var normal = null
			if attach_to:
				normal = Vector2.UP
			else:
				normal = collision.get_normal()
				velocity = velocity.bounce(normal) * Global.bounce_amount
				
			if is_on_floor_custom(normal):
				if !landed:
					if !action_executed:
						if current_item.has_action:
							if current_item.name == "bomb" or current_item.name == "smoke":
								count_down = 3
								#$lbl_count.visible = true
							else:
								count_down = 1.1
						
					noise_time = 0.3
					$AnimationPlayer2.play("new_animation")
					Global.emit(global_position, 1)
					$noise/collider.set_deferred("disabled", false)
					
					Global.play_sound(Global.GizmoDropSFX)
				landed = true 
				
		if !landed:
			rotation += 5 * delta
		else:
			$sprite.material.set_shader_parameter("gizmomode", gizmo_mode)
			if current_item.has_action:
				if count_down > 0:
					count_down -= 1 * delta
					$lbl_count.text = str(int(count_down)) 
					if count_down < 2:
						gizmo_mode = true
						$sprite.material.set_shader_parameter("gizmomode", gizmo_mode)
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
		
func droped(_parent, _parent_lbl, direction, _current_item, _simulation = false, _from_enemy = false):
	Global.play_sound(Global.GizmoLaunchSFX)
	parent_lbl = _parent_lbl
	parent = _parent
	from_enemy = _from_enemy
	velocity = direction
	friction = 0.1
	simulation = _simulation
	current_item = _current_item
	if current_item.full_scale:
		if current_item.name == "spikeball":
			$sprite.scale.x = 2
			$sprite.scale.y = 2
		else:
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
		if from_enemy:
			$sprite.animation = "bomb"
		else:
			$sprite.animation = Global.gunz_equiped[Global.gunz_index].name
		$Line2D.visible = false
		$Line2D.queue_free()
	
func do_action(_player, lbl):
	$lbl_count.visible = false
	if !simulation and !action_executed:
		if landed:
			if current_item.has_action:
				action_executed = true
				if !from_enemy:
					lbl.visible = true
					lbl.text = current_item.dialog.to_upper() + "!"
				
			if current_item.name == "teleport":
				Global.play_sound(Global.TeleportSFX)
				Global.emit(_player.global_position, 10)
				action_executed = true
				_player.visible = false
				_player.global_position = $mark.global_position
				_player.teleported()
				Global.emit(_player.global_position, 10)
			elif current_item.name == "clone":
				Global.play_sound(Global.CloneSFX)
				action_executed = true
				var pclone = player_clone.instantiate()
				pclone.global_position = $mark.global_position
				pclone.iam_clone = true
				get_parent().add_child(pclone)
				Global.emit(pclone.global_position, 10)
				queue_free()
			elif current_item.name == "bomb":
				action_executed = true
				Global.play_sound(Global.BombSFX)
				explode()
			elif current_item.name == "spring":
				action_executed = true
				create_spring_object()
				queue_free()
			elif current_item.name == "plant":
				Global.play_sound(Global.PlantGrowSFX)
				action_executed = true
				create_plant_object()
				queue_free()
			elif current_item.name == "smoke":
				Global.play_sound(Global.SmokeBombSFX)
				action_executed = true
				create_smoke_object()
				queue_free()	
				
			if current_item.has_action:
				_player.visible = true
				if !from_enemy:
					_player.lbl_hide_delegate(false, 1)
			
func create_spring_object():
	var spring_o = spring_obj.instantiate()
	spring_o.global_position = $mark.global_position - Vector2(0, 3)
	get_parent().add_child(spring_o)
	Global.emit(global_position, 10)
	
func create_plant_object():
	var plant_o = plant_obj.instantiate()
	plant_o.global_position = $mark.global_position - Vector2(0, 3)
	get_parent().add_child(plant_o)
	Global.emit(global_position, 10)
	
func create_smoke_object():
	var smoke_o = smoke_obj.instantiate()
	smoke_o.global_position = $mark.global_position - Vector2(0, 16)
	get_parent().add_child(smoke_o)
	Global.emit(global_position, 10)
	Global.shaker_obj.shake(20, 2.1)
	
func explode():
	if !simulation:
		attach_to = null
		visible = true
		$sprite.visible = false
		$explosion/collider.set_deferred("disabled", false)
		$explosion_mini/collider.set_deferred("disabled", false)
		$explosion_mini/collider2.set_deferred("disabled", false)
		$explosion_mini/collider3.set_deferred("disabled", false)
		explosion_delay = 1.2
		$explosion_light.enabled = true
		$explosion_light.enabled = true
		$explosion_light.enabled = true
		$anim_explosion.play("new_animation")
		$explosions.explode()

func _on_area_body_entered(body):
	if !simulation:
		if body and body.is_in_group("enemies") and body.is_in_group("eater"):
			body.eat_gizmo(current_item)
			Global.emit(global_position, 1)
			if current_item.name == "teleport":
				queue_free()
			elif current_item.name == "clone":
				queue_free()
			elif current_item.name == "bomb":
				visible = false
				velocity = Vector2.ZERO
				attach_to = body
			elif current_item.name == "spring":
				queue_free()
			elif current_item.name == "muffin":
				queue_free()
			elif current_item.name == "plant":
				queue_free()
			elif current_item.name == "smoke":
				visible = false
				velocity = Vector2.ZERO
				attach_to = body
			elif current_item.name == "spikeball":
				pass
			
		elif body and !from_enemy and body.is_in_group("players") and !body.is_in_group("prisoners"):
			Global.play_sound(Global.InteractSFX)
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
	Global.emit(global_position, 2)
	velocity.y = jump_speed * 2

func set_red_color(val):
	$sprite.material.set_shader_parameter("gizmomode", gizmo_mode)
	$sprite.material.set_shader_parameter("crisis", val)
