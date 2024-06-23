extends Node2D

func _ready():
	if randi() % 3 == 0:
		queue_free()
