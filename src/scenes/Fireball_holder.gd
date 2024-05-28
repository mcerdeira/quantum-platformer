extends Node2D

func _ready():
	if randi() % 2 == 0: 
		queue_free()

func _physics_process(delta):
	rotation += 1 * delta
