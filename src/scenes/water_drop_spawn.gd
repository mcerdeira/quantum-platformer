extends Node2D
@export var total_ttl = 8

func _ready():
	if total_ttl == -1:
		total_ttl = randi() % 9 + 1
	$waterdrop.total_ttl = total_ttl
	$waterdrop.set_ttl()
