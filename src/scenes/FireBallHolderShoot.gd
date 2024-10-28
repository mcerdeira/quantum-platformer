extends Area2D
var speed = 80.0
var direction = Vector2.RIGHT
var master_parent = null

func _ready():
	add_to_group("fireballholder")
	if Global.BOSS_ROOM:
		speed = 100.0

func _physics_process(delta):
	if Global.BOSS_ROOM: 
		if Global.BULLETS_MOVE:
			translate(direction * speed * delta)
	else:
		translate(direction * speed * delta)

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		Global.emit(global_position, 5)
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("movebable"):
		Global.emit(global_position, 5)
		queue_free()
