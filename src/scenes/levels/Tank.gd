extends CharacterBody2D
var tspeed = 0.0
var bullet_o = load("res://scenes/bullet.tscn")
@export var player_input = true
@export var gameman : Node2D

func _ready():
	add_to_group("tanks")
	if player_input:
		gameman.rotation_update($sprite/sprite.rotation)
		gameman.speed_update(tspeed)
		
func die():
	visible = false
	if player_input:
		gameman.lose()
	else:
		gameman.win()

func _physics_process(delta):
	if player_input:
		if Input.is_action_pressed("down"):
			$sprite/sprite.rotation += 1 * delta
			gameman.rotation_update($sprite/sprite.rotation)
		elif Input.is_action_pressed("up"):
			$sprite/sprite.rotation -= 1 * delta
			gameman.rotation_update($sprite/sprite.rotation)
			
		if Input.is_action_pressed("right"):
			tspeed += 100 * delta
			gameman.speed_update(tspeed)
		elif Input.is_action_pressed("left"):
			tspeed -= 100 * delta
			if tspeed <=0:
				tspeed = 0
			gameman.speed_update(tspeed)
			

		if Input.is_action_just_pressed("shoot"):
			var Main = get_node("/root/Main")
			var bullet = bullet_o.instantiate()
			bullet.rotation = $sprite/sprite.rotation
			bullet.global_position = $sprite/sprite/Marker2D.global_position
			get_parent().add_child(bullet)
			gameman.shoot()
			
			bullet.droped(Vector2.from_angle($sprite/sprite.rotation) * tspeed)
