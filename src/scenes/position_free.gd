extends Area2D
var free = true

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var coords = body.get_coords_for_body_rid(body_rid)
		if body.get_cell_source_id(0, coords) == 0:
			free = false 

func _on_area_entered(area):
	if area and area.is_in_group("smoke_obj"):
		free = false 
