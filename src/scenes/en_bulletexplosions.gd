extends Node2D

func start():
	$"../Timer2".start()
	
func stop():
	$"../Timer2".stop()

func explode():
	var childs = get_children()
	for c in childs:
		if randi() % 2 == 0:
			Global.emit(c.global_position, 3)

func _on_timer_2_timeout():
	explode()
