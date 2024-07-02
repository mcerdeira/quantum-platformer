extends Area2D
var new_tile_id = Global.DestructedID

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var coords = body.get_coords_for_body_rid(body_rid)
		if body.get_cell_source_id(0, coords) == Global.DestructibleID:
			Global.emit(coords, 12)
			body.set_cell(0, coords, new_tile_id, Vector2(0, 0))
