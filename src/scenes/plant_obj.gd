extends CharacterBody2D
var done = false
var gravity = 1000.0

func _ready():
	global_position.y += 16
	
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()

func _on_growing_plant_animation_finished():
	Global.play_sound(Global.PlantGrowSFX)
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
	$flowerline.points[0].y = $flower.position.y

func _on_detect_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var coords = body.get_coords_for_body_rid(body_rid)
		if body.get_cell_source_id(0, coords) == 0:#PLANT
			$Timer.stop()
