extends Node2D
var tspeed = 700.0
var bullet_o = load("res://scenes/bullet.tscn")
@export var player_input = true

func _physics_process(delta):
	if player_input:
		if Input.is_action_pressed("down"):
			$sprite/sprite.rotation += 1 * delta
		elif Input.is_action_pressed("up"):
			$sprite/sprite.rotation -= 1 * delta

		if Input.is_action_just_pressed("jump"):
			var Main = get_node("/root/Main")
			var bullet = bullet_o.instantiate()
			bullet.rotation = $sprite/sprite.rotation
			bullet.global_position = $sprite/sprite/Marker2D.global_position
			get_parent().add_child(bullet)
			
			bullet.droped(Vector2.from_angle($sprite/sprite.rotation) * tspeed)
