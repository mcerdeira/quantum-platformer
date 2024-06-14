extends Node2D

func _ready():
	$sprite.frame = randi() % 5
