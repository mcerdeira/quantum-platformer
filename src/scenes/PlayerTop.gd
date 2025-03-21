extends Area2D
var moving = false
var speed = 100
var ttl_drop = 0.0
var rainobj = preload("res://scenes/Rain.tscn")
var waterdrop = preload("res://scenes/water_drp.tscn")
var rain = null
var dead = false
var dead_animation = ""

func _ready():
	add_to_group("players")
	Global.player_obj = self
	Global.Fader.fade_out()
	rain = rainobj.instantiate()
	rain.manual_thunders = true
	rain.position = Vector2(-431, -267) 
	add_child(rain)

func create_drop(pos):
	if ttl_drop <= 0:
		ttl_drop = 0.5
		var drop = waterdrop.instantiate()
		drop.position = Vector2(pos.x, pos.y + 16)
		get_parent().add_child(drop)
		
func force_thunder():
	rain.force_thunder()
	
func kill_fire():
	Global.play_sound(Global.LavaFallSFX)
	Global.emit(global_position, 10)
	dead = true
	dead_animation = "dead_fire"

func _physics_process(delta):
	if dead:
		Global.GAMEOVER = dead
		if Global.GAMEOVER:
			Global.OverWorldFromGameOver = true
		
		$sprite.animation = dead_animation
		$sprite_eyes.animation = $sprite.animation
	else:
		moving = false
		ttl_drop -= 1 * delta
		if Input.is_action_pressed("left"):
			create_drop(global_position)
			moving = true
			position.x -= speed * delta
			$sprite.scale.x = -1
		elif Input.is_action_pressed("right"):
			create_drop(global_position)
			moving = true
			position.x += speed * delta
			$sprite.scale.x = 1
		elif Input.is_action_pressed("up"):
			create_drop(global_position)
			moving = true
			position.y -= speed * delta
		elif Input.is_action_pressed("down"):
			create_drop(global_position)
			moving = true
			position.y += speed * delta
			
		if moving:
			$sprite.play()
			$sprite_eyes.play()
			$sprite.animation = "walking"
			$sprite_eyes.animation = $sprite.animation
		else:
			$sprite.play()
			$sprite_eyes.play()
			$sprite.animation = "idle"
			$sprite_eyes.animation = $sprite.animation
			
		$sprite_eyes.scale.x = $sprite.scale.x
		$PlayerReflect/sprite.scale.x = $sprite.scale.x
		$PlayerReflect/sprite_eyes.scale.x = $sprite.scale.x
		
		$PlayerReflect/sprite.animation = $sprite.animation
		$PlayerReflect/sprite_eyes.animation = $sprite_eyes.animation
		$PlayerReflect/sprite.play()
		$PlayerReflect/sprite_eyes.play()
	
