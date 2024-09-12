extends Camera2D
@export var zoom_final : Vector2 = Vector2(0, 0)
@export var zoom_speed = 0.1

func _ready():
	Global.shaker_obj.camera = self

func _process(delta):
	Global.shaker_obj.camera = self
	zoom = lerp(zoom, zoom_final, zoom_speed)
