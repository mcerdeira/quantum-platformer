extends Node2D
@export var fixed = false 
var speed = 10

func _ready():
	if !fixed:
		if randi() % 2 == 0: 
			queue_free()

func _physics_process(delta):
	rotation_degrees += speed * delta
