extends Node2D
var speed = 100
var dir = 1

func _ready() -> void:
	if Global.TerminalNumber != Global.TerminalsEnum.TOMB:
		visible = false
		queue_free() 

func _physics_process(delta: float) -> void:
	if global_position.x <= -408 and dir == -1:
		dir = 1
	if global_position.x >= 4608 and dir == 1: 
		dir = -1
		
	if dir == 1:
		position.x += speed * delta
		$SubViewport/Node3D/skeleton_staff_gltf.rotation_degrees.y = lerp($SubViewport/Node3D/skeleton_staff_gltf.rotation_degrees.y, 45.0, 0.1)
	else:
		position.x -= speed * delta
		$SubViewport/Node3D/skeleton_staff_gltf.rotation_degrees.y = lerp($SubViewport/Node3D/skeleton_staff_gltf.rotation_degrees.y, -45.0, 0.1)
