extends Node2D
var fires = preload("res://scenes/FireBall.tscn")
var lampfaller = preload("res://scenes/lamp_faller.tscn")

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
		
		#TODO: Armar una estructura similar al lampfaller
		var parent = get_node("/root/Main")
		var p = lampfaller.instantiate()
		p.global_position = c.global_position
		parent.add_child(p)
#
		#var parent = get_parent().get_parent() #get_node("/root/Main")
		#var p = fires.instantiate()
		#p.global_position = c.global_position
		#p.free_fireball = true
		#p.visible = false
		##p.tt_total = 1.5
		#parent.add_child(p)
