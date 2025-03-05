extends MeshInstance3D
var speed = 2

func _physics_process(delta):
	rotation.y -= speed * delta 
	rotation.z += speed * delta 
