extends Area2D

func _on_body_entered(body):
	if body and body.is_in_group("enemies"):
		body.level_parent = get_parent()
	
	if body and body.is_in_group("players") and !body.is_in_group("prisoners"):
		body.level_parent = get_parent() 
		Global.map_obj.notify_map(get_parent().q)
		
	if body and body.is_in_group("prisoners"):
		body.level_parent = get_parent() 
		Global.map_obj.notify_prisoner_done(get_parent().q)

func _on_area_entered(area):
	if area and area.get_parent() and area.get_parent().is_in_group("prisoners"):
		Global.map_obj.notify_prisoner(get_parent().q)
