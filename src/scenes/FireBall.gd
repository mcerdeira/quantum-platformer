extends Area2D
var fires = preload("res://scenes/Fires.tscn")
@export var free_fireball = false


func _on_body_entered(body):
	if body and (body.is_in_group("players") or body.is_in_group("enemies")):
		body.kill_fire()

func _physics_process(delta):
	$sprite.rotation += 10 * delta

func _on_body_shape_entered(body_rid, body, _body_shape_index, _local_shape_index):
	if body is TileMap:
		var coords = body.get_coords_for_body_rid(body_rid)
		if body.get_cell_source_id(0, coords) == Global.BurnableID:
			var c = body.map_to_local(coords)
			var global_coords = c
			body.set_cell(0, coords, Global.BurnedID, Vector2(0, 0))
			
			var parent = get_parent().get_parent()
			if parent:
				if free_fireball:
					parent = get_parent().master_parent
					if !parent:
						#TODO: Ver que pasa con esto!!!
						parent = get_parent().get_parent()
					
				if parent:
					var p = fires.instantiate()
					p.position = global_coords
					parent.add_child(p)
					Global.emit(global_position, 5)

func _on_area_entered(area):
	if free_fireball:
		if area.is_in_group("qdetector"):
			if get_parent().master_parent == null:
				get_parent().master_parent = area.get_parent() 
