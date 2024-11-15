extends Node2D

func start():
	$"../Timer2".start()
	
func stop():
	$"../Timer2".stop()

func explode():
	var childs = get_children()
	for c in childs:
		if randi() % 2 == 0:
			Global.emit(c.global_position, 3, null, 3)

func _on_timer_2_timeout():
	if randi() % 2 == 0:
		var bicho = Global.pick_random([Global.BichoFeoSFX, Global.BichoFeo2SFX])
		var sfx = Global.pick_random([bicho, Global.DoorOpensSFX])
		Global.play_sound(sfx)
		
	explode()
