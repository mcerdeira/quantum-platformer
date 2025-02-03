extends Node2D
var moving = false
var speed = 100
var rainobj = preload("res://scenes/Rain.tscn")

func _ready():
	Global.player_obj = self
	Global.Fader.fade_out()
	var rain = rainobj.instantiate()
	rain.position = Vector2(-431, -267) 
	add_child(rain)

func _physics_process(delta):
	moving = false
	if Input.is_action_pressed("left"):
		moving = true
		position.x -= speed * delta
		$sprite.scale.x = -1
	elif Input.is_action_pressed("right"):
		moving = true
		position.x += speed * delta
		$sprite.scale.x = 1
	elif Input.is_action_pressed("up"):
		moving = true
		position.y -= speed * delta
	elif Input.is_action_pressed("down"):
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
	
