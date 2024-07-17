extends MeshInstance3D
var speed = 4

func _physics_process(delta):
	if Global.player_obj:
		Global.player_obj.terminal_mode = true
		if Input.is_action_pressed("left"):
			rotation.y -= speed * delta 
		if Input.is_action_pressed("right"):
			rotation.y += speed * delta 
		if Input.is_action_pressed("up"):
			rotation.z += speed * delta 
		if Input.is_action_pressed("down"):
			rotation.z -= speed * delta 
