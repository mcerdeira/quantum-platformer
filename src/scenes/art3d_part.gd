extends MeshInstance3D
var speed = 1
@export var part_n = 0
var active = false
var parent = null

func _ready():
	parent = get_parent()

func _physics_process(delta):
	active = (parent.active_number == part_n)
	if active:
		if Input.is_action_pressed("left"):
			rotation.y -= speed * delta 
		if Input.is_action_pressed("right"):
			rotation.y += speed * delta 
