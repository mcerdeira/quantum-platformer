extends Camera2D
@export var zoom_final : Vector2 = Vector2(0, 0)
@export var zoom_speed = 0.1

func _process(delta):
	zoom = lerp(zoom, zoom_final, zoom_speed)
