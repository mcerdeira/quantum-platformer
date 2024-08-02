extends MeshInstance3D
var speed = 4
@export var part_n = 0
var active = false
var parent = null

func _ready():
	parent = get_parent()

func _physics_process(delta):
	active = parent.active_number
	if active:
		if Input.is_action_pressed("left"):
			rotation.y -= speed * delta 
		if Input.is_action_pressed("right"):
			rotation.y += speed * delta 
		if Input.is_action_pressed("up"):
			rotation.z += speed * delta 
		if Input.is_action_pressed("down"):
			rotation.z -= speed * delta 
