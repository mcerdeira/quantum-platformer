extends MeshInstance3D
var speed = 2

func _physics_process(delta):
	if Input.is_action_pressed("left"):
		rotation.y -= speed * delta 
	if Input.is_action_pressed("right"):
		rotation.y += speed * delta 
	if Input.is_action_pressed("up"):
		rotation.z += speed * delta 
	if Input.is_action_pressed("down"):
		rotation.z -= speed * delta 
