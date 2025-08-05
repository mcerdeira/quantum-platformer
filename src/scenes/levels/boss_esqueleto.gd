extends Node2D
var speed = 100
var dir = 1
var ttl_change_dir = 5.0

func _physics_process(delta: float) -> void:
	ttl_change_dir -= 1 * delta
	if ttl_change_dir <= 0:
		ttl_change_dir = 5.0
		dir *= -1
		
	if dir == 1:
		position.x += speed * delta
		$SubViewport/Node3D/skeleton_staff_gltf.rotation_degrees.y = lerp($SubViewport/Node3D/skeleton_staff_gltf.rotation_degrees.y, 45.0, 0.1)
	else:
		position.x -= speed * delta
		$SubViewport/Node3D/skeleton_staff_gltf.rotation_degrees.y = lerp($SubViewport/Node3D/skeleton_staff_gltf.rotation_degrees.y, -45.0, 0.1)
