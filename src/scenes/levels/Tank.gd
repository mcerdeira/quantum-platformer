extends CharacterBody2D
var tspeed = 0.0
var bullet_o = load("res://scenes/bullet.tscn")
@export var player_input = true
@export var gameman : Node2D
var ia_decided = false
var ia_rotation = 0.0
var ia_tspeed = 0.0
var ia_shooted = false

func _ready():
	add_to_group("tanks")
	if player_input:
		gameman.rotation_update($sprite/sprite.rotation)
		gameman.speed_update(tspeed)
	else:
		$sprite/sprite.rotation_degrees = -180
		
func die():
	visible = false
	if player_input:
		gameman.lose()
	else:
		gameman.win()

func _physics_process(delta):
	if !visible or gameman.game_ended:
		return
		
	if player_input:
		if gameman.player_turn:
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
				bullet.gameman = gameman
				get_parent().add_child(bullet)
				gameman.shoot()
				
				bullet.droped(Vector2.from_angle($sprite/sprite.rotation) * tspeed)
	else:
		if !gameman.player_turn and !ia_shooted:
			if !ia_decided:
				ia_decided = true
				ia_shooted = false
				ia_rotation = randf_range(-179, -97)
				ia_tspeed = randf_range(500.00, 1200.0)
			
			$sprite/sprite.rotation_degrees = lerp($sprite/sprite.rotation_degrees, ia_rotation, 0.1)
			tspeed = lerp(tspeed, ia_tspeed, 0.1)
			
			if ok_to_shoot():
				ia_shooted = true
				ia_decided = false
				var Main = get_node("/root/Main")
				var bullet = bullet_o.instantiate()
				bullet.rotation = $sprite/sprite.rotation
				bullet.global_position = $sprite/sprite/Marker2D.global_position
				bullet.gameman = gameman
				bullet.tank = self
				get_parent().add_child(bullet)
				gameman.shoot()
				
				bullet.droped(Vector2.from_angle($sprite/sprite.rotation) * tspeed)

func ok_to_shoot():
	if abs($sprite/sprite.rotation_degrees - ia_rotation) <= 0.1 and abs(tspeed - ia_tspeed) <= 0.1:
		return true
	else:
		return false

func reboot():
	ia_shooted = false
	ia_decided = false
