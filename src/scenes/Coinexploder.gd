extends RigidBody2D
var impulse_force = 300.0

func _ready():
	explode()

func explode():
	impulse_force = impulse_force * Global.pick_random([1.0, 1.3, 1.4, 1.5, 2.0])
	var direction = Vector2(randf_range(-1, 1), randf_range(-1, 0)).normalized()
	apply_impulse(direction * impulse_force)