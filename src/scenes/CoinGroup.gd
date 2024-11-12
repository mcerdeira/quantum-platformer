extends Node2D

func _ready():
	if randi() % 10 == 0:
		queue_free()
