extends Node2D
var done = false

func _ready():
	global_position.y += 16

func _on_growing_plant_animation_finished():
	done = true
	Global.emit($flower.global_position, 1)
	$flower.visible = true
	$flower.play()
	$Timer.start()

func _on_timer_timeout():
	Global.emit(global_position, 1)
	$Stair.scale.y += 1
	$flower.global_position.y -= 32
	Global.emit($flower.global_position, 1)
	#var pepep : Line2D
	#pepep.points[0].y = $flower.global_position.y
	$flowerline.points[0].y = $flower.position.y


func _on_detect_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var coords = body.get_coords_for_body_rid(body_rid)
		if body.get_cell_source_id(0, coords) == 0:
			$Timer.stop()
