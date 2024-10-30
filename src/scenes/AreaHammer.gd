extends Area2D
@export var direction = "right"

func _ready():
	add_to_group("hammer_" + direction)
