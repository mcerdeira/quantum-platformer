extends Area2D
var speed = 80.0
var direction = Vector2.RIGHT
var master_parent = null

func _ready():
	add_to_group("fireballholder")

func _physics_process(delta):
	translate(direction * (speed * Global.time_speed) * delta)

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		Global.emit(global_position, 5)
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("movebable"):
		Global.emit(global_position, 5)
		queue_free()
