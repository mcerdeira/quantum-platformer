extends Node2D
@export var fixed = false
@export var speed = 1.0

func _ready():
	if !fixed:
		if randi() % 2 == 0: 
			queue_free()

func _physics_process(delta):
	rotation += speed * delta
