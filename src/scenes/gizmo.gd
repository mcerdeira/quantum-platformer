extends CharacterBody2D
var gravity = 10.0
var speed = 75.0
var grabbed = false
var total_friction = 0.3
var friction = total_friction
var landed = false
var simulation = false
var ttl = 0.5

func _ready():
	add_to_group("interactuable")
	
func _physics_process(delta):
	if simulation:
		ttl -= 1 * delta 
		if ttl <= 0:
			visible = false
			queue_free()
	
	if !is_on_floor():
		landed = false
		if !simulation:
			rotation += 5 * delta
		velocity.y += gravity
	else:
		rotation = 0
		velocity.x = lerp(velocity.x, 0.0, friction)
		landed = true

		if abs(velocity.x) <= 0.0:
			velocity.x = 0.0
			friction = total_friction
		
	move_and_slide()
	
func droped(direction, _simulation = false):
	velocity = direction
	friction = 0.1
	simulation = _simulation
	if simulation:
		set_collision_layer_value(2, true)
		set_collision_mask_value(2, true)
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
		$area.set_collision_layer_value(2, true)
		$area.set_collision_mask_value(2, true)
		$area.set_collision_layer_value(1, false)
		$area.set_collision_mask_value(1, false)
		$sprite.animation = "simul"
		
		modulate.a = 0.2
	
func do_action(_player):
	if landed:
		Global.emit(_player.global_position, 10)
		_player.visible = false
		_player.global_position = $mark.global_position
		Global.emit(_player.global_position, 10)
		_player.visible = true

func _on_area_body_entered(body):
	if body and body.is_in_group("players"):
		queue_free()
