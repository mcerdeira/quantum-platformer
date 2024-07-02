extends Area2D
var ttl = 10
var smoke_obj = load("res://scenes/smoke_obj.tscn")
var iteration = 0
var go_up = true
var go_down = true
var go_left = true
var go_right = true

func _ready():
	add_to_group("smoke_obj")
	$AnimationPlayer.play("new_animation")
	$sprite.play()
	
func _physics_process(delta):
	ttl -= 1 * delta
	if ttl <= 0:
		Global.emit(global_position, 10)
		queue_free()
		return
	
func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var coords = body.get_coords_for_body_rid(body_rid)
		if body.get_cell_source_id(0, coords) == 0:#SMOKE
			$Timer.stop()

func _on_timer_timeout():
	if iteration <= 4:
		$Timer.stop()
		if $position_free_up.free:
			create_smoke_object(Vector2(global_position.x, global_position.y - 32))
			
		if $position_free_down.free:
			create_smoke_object(Vector2(global_position.x, global_position.y + 32))
			
		if $position_free_left.free:
			create_smoke_object(Vector2(global_position.x - 32, global_position.y))
			
		if $position_free_right.free:
			create_smoke_object(Vector2(global_position.x + 32, global_position.y))

func create_smoke_object(pos):
	var smoke_o = smoke_obj.instantiate()
	smoke_o.global_position = pos
	smoke_o.iteration = iteration + 1
	get_parent().add_child(smoke_o)
	Global.emit(global_position, 10)
