extends Node2D
var fires = preload("res://scenes/FireBall.tscn")
var firespawner = preload("res://scenes/FireSpawner.tscn")

func explode():
	$blast.visible = true
	$blast2.visible = true
	$blast3.visible = true
	
	$blast.play()
	$blast2.play()
	$blast3.play()
	
	Global.shaker_obj.shake(20, 2.1, null, global_position)
	
	var childs = get_children()
	for c in childs:
		Global.emit(c.global_position, 3)
		
		var parent = get_node("/root/Main")
		var p = firespawner.instantiate()
		p.global_position = c.global_position
		parent.add_child(p)
