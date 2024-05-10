extends CharacterBody2D
var gravity = 10.0
var speed = 75.0
var jump_speed = -300.0
var grabbed = false
var total_friction = 0.3
var friction = total_friction
var landed = false
var simulation = false
var ttl = 0.5
var player_clone = load("res://scenes/player.tscn")
var noise_time = 0
var explosion_delay = 0
var blowed = 0

func _ready():
	add_to_group("interactuable")
	
func _physics_process(delta):
	if !is_on_floor():
		landed = false
		if !simulation:
			rotation += 5 * delta
		velocity.y += gravity
	else:
		rotation = 0
		if blowed <= 0:
			velocity.x = lerp(velocity.x, 0.0, friction)
		else:
			blowed -= 1 * delta

		if !landed:
			if !simulation:
				noise_time = 0.3
				Global.emit(global_position, 1)
				$noise/collider.set_deferred("disabled", false)
		
		landed = true
		
		if explosion_delay > 0:
			explosion_delay -= 1 * delta
			if explosion_delay <= 0:
				queue_free()
		
		if noise_time > 0:
			noise_time -= 1 * delta
			if noise_time <= 0:
				$noise/collider.set_deferred("disabled", true)
	
		if abs(velocity.x) <= 0.0:
			velocity.x = 0.0
			friction = total_friction
		
	move_and_slide()
	
func droped(direction, _simulation = false):
	velocity = direction
	friction = 0.1
	simulation = _simulation

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
		$sprite.animation = Global.gunz_equiped[Global.gunz_index]
		$Line2D.visible = false
		$Line2D.queue_free()
	
func do_action(_player, lbl, item_action):
	if !simulation:
		if landed:
			if item_action != "rock":
				lbl.visible = true
				lbl.text =  item_action.to_upper() + "!"
			if item_action == "teleport":
				Global.emit(_player.global_position, 10)
				_player.visible = false
				_player.global_position = $mark.global_position
				Global.emit(_player.global_position, 10)
			elif item_action == "clone":
				var pclone = player_clone.instantiate()
				pclone.global_position = $mark.global_position
				pclone.iam_clone = true
				get_parent().add_child(pclone)
				Global.emit(pclone.global_position, 10)
			elif item_action == "bomb":
				explode()
				
			if item_action != "rock":
				_player.visible = true
				_player.lbl_hide_delegate(false, 1)
				if item_action != "bomb":
					queue_free()
			
func explode():
	if !simulation:
		$explosion/collider.set_deferred("disabled", false)
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
