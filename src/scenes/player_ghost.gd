extends CharacterBody2D
var speed = 215.0
var resurrecting = 0
var intro = 2

func _ready():
	add_to_group("interactuable")

func _physics_process(delta):
	if intro > 0:
		intro -= 1 * delta
		velocity.y = lerp(velocity.y, -speed / 3, 0.7)
	if intro <= 0:
		velocity.y = 0
	
	$lbl_count.text = str(round(resurrecting))
	
	if intro <= 0:
		if Input.is_action_pressed("up"):
			velocity.y = lerp(velocity.y, -speed, 0.7)
		elif Input.is_action_pressed("down"):
			velocity.y = lerp(velocity.y, speed, 0.7)
		else:
			velocity.y = lerp(velocity.y, 0.0, 1.0)
				
		if Input.is_action_pressed("left"):
			velocity.x = lerp(velocity.x, -speed, 0.7)
			$sprite.flip_h = true
		elif Input.is_action_pressed("right"):
			velocity.x = lerp(velocity.x, speed, 0.7)
			$sprite.flip_h = false
		else:
			velocity.x = lerp(velocity.x, 0.0, 1.0)
	
	move_and_slide()

func kill_fall():
	pass
