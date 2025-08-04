extends Area2D

func _ready():
	add_to_group("bosses")
	
func force_kill():
	pass

func flyaway():
	if $"..".visible:
		$"../..".flyaway()
