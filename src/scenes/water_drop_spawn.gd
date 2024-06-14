extends Node2D
@export var total_ttl = 8

func _ready():
	$waterdrop.total_ttl = total_ttl
	$waterdrop.set_ttl()
