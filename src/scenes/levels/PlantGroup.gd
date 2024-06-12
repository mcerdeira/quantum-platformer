extends Node2D
@export var fixed = true

func _ready():
	if !fixed:
		if randi() % 2 == 0:
			queue_free()
