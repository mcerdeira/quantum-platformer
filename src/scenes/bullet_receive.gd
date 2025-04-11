extends Area2D

func _ready():
	add_to_group("bosses")

func flyaway():
	if $"..".visible:
		$"../..".flyaway()
