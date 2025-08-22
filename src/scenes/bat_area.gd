extends Area2D


func _ready() -> void:
	add_to_group("bat_area")
	add_to_group("bats")

func flyaway(dir):
	get_parent().flyaway(dir)
	
func kill_fire():
	get_parent().kill_fire()
