extends Area2D
@export var plant_stair = false

func _ready():
	add_to_group("stairs")
	if plant_stair:
		add_to_group("plant_stair")
