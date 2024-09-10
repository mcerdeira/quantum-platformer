extends Sprite2D
var shake_intensity = 5.0
var rotate_speed = 10.0

func _ready():
	rotation_degrees = randi() % 361 

func _physics_process(delta):
	rotation_degrees += rotate_speed * delta
	offset = Vector2(randf(), randf()) * shake_intensity
