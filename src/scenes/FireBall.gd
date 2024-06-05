extends Area2D
var fires = preload("res://scenes/Fires.tscn")

func _on_body_entered(body):
	if body and (body.is_in_group("players") or body.is_in_group("enemies")):
		body.kill_fire()

func _physics_process(delta):
	$sprite.rotation += 10 * delta

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var coords = body.get_coords_for_body_rid(body_rid)
		if body.get_cell_source_id(0, coords) == 4:
			var c = body.map_to_local(coords)
			var global_coords = c
			body.set_cell(0, coords, 5, Vector2(0, 0))
			
			var parent = get_parent().get_parent()
			var p = fires.instantiate()
			parent.add_child(p)
			p.position = global_coords
			Global.emit(global_position, 5)
