extends Node2D

func explode():
	$blast.visible = true
	$blast2.visible = true
	$blast3.visible = true
	
	$blast.play()
	$blast2.play()
	$blast3.play()
	
	Global.shaker_obj.shake(20, 2.1)
	
	var childs = get_children()
	for c in childs:
		Global.emit(c.global_position, 3)
