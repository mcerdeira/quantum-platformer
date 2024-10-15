extends Area2D

func _ready():
	add_to_group("bicho_feo")


func slow_down():
	get_parent().slow_down()
