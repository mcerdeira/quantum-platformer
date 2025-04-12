extends Area2D
var direction = ""
var speed = 315.0
var ttl = 0.7

func _physics_process(delta: float) -> void:
	ttl -= 1 * delta
	if ttl <= 0:
		Global.emit(global_position, 5)
		queue_free()
	else:
		if randi() % 15 == 0:
			Global.emit(global_position, 1)
			
		if direction == "right":
			position.x += speed * delta
		else:
			position.x -= speed * delta
		
func ok_hit(body):
	return body.falling or body.attacking or body.jumping
		
func _on_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("bosses") and ok_hit(body):
		Global.emit(global_position, 5)
		body.flyaway()

func _on_area_entered(area: Area2D) -> void:
	if area and area.is_in_group("bosses"):
		Global.emit(global_position, 5)
		area.flyaway()
	
	if area and area.is_in_group("fireballholder"):
		Global.emit(global_position, 5)
		area.queue_free()
		queue_free()

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is TileMap:
		Global.emit(global_position, 5)
		queue_free()
