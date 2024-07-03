extends Node2D
var fires = preload("res://scenes/Fires.tscn")

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

		var parent = get_node("/root/Main")
		var p = fires.instantiate()
		p.global_position = c.global_position
		p.visible = false
		p.tt_total = 2
		parent.add_child(p)
