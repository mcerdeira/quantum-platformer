extends Node2D

func explode():
	var childs = get_children()
	for c in childs:
		if randi() % 4 == 0:
			Global.emit(c.global_position, 1)

func _on_timer_timeout():
	explode()
