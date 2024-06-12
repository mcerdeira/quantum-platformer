extends Node2D
@export var fixed = false

func _ready():
	if !fixed:
		if randi() % 2 == 0: 
			queue_free()

func _physics_process(delta):
	rotation += 1 * delta
