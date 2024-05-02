extends CharacterBody2D
var gravity = 10.0
var speed = 75.0
var grabbed = false
var total_friction = 0.3
var friction = total_friction
var landed = false

func _ready():
	add_to_group("interactuable")
	
func _physics_process(delta):
	if !is_on_floor():
		landed = false
		rotation += 10 * delta
		velocity.y += gravity
	else:
		rotation = 0
		velocity.x = lerp(velocity.x, 0.0, friction)
		landed = true
		if abs(velocity.x) <= 0.0:
			velocity.x = 0.0
			friction = total_friction
			$collider.set_deferred("disabled", true)
		
	move_and_slide()
	
func droped(direction):
	$collider.set_deferred("disabled", false)
	velocity = direction
	friction = 0.1
	
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
