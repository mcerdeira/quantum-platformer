extends Camera2D
var positionted = false
var speed = 250

func _ready():
	$BinocularCircle.visible = false
	Global.global_camera = self

func _physics_process(delta: float) -> void:
	if enabled:
		if !positionted:
			positionted = true
			$BinocularCircle.visible = true
			if Global.player_obj:
				global_position = Global.player_obj.global_position
		else:
			if Input.is_action_pressed("up"):
				global_position.y -= speed * delta
			elif Input.is_action_pressed("down"):
				global_position.y += speed * delta
			elif Input.is_action_pressed("left"):
				global_position.x -= speed * delta
			elif Input.is_action_pressed("right"):
				global_position.x += speed * delta
				
			if global_position.y > 2351:
				global_position.y = 2351
			if global_position.y < 239:
				global_position.y = 239
	else:
		$BinocularCircle.visible = false
		positionted = false
		
