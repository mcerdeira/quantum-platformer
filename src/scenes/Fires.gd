extends Area2D
var ttl = 1
var tt_total = 7
var fires = preload("res://scenes/Fires.tscn")
var kill_me = null

func _physics_process(delta):
	if ttl > 0:
		ttl -= 1 * delta
		if ttl <= 0:
			Global.emit(global_position, 5)
			$collider.set_deferred("disabled", false)
			$collider4.set_deferred("disabled", false)
			$collider5.set_deferred("disabled", false)
			$collider2.set_deferred("disabled", false)
			$collider3.set_deferred("disabled", false)
	
	tt_total -= 1 * delta
	if tt_total <= 0:
		Global.emit(global_position, 5)
		if kill_me and is_instance_valid(kill_me):
			kill_me.dead_fire()
		queue_free() 

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var coords = body.get_coords_for_body_rid(body_rid)
		if body.get_cell_source_id(0, coords) == 4:
			var c = body.map_to_local(coords)
			var global_coords = c
			body.set_cell(0, coords, 5, Vector2(0, 0))
			
			var parent = get_parent()
			var p = fires.instantiate()
			p.position = global_coords
			parent.add_child(p)
			Global.emit(global_position, 5)
			
func _on_body_exited(body):
	if body and (body.is_in_group("players") or body.is_in_group("enemies")):
		body.kill_fire()
