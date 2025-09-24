extends RigidBody2D
var impulse_force = 250.0
var explode_ttl = 0.0

func _ready():
	add_to_group("interactuable_coin")
	continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE
	explode()
	
func _physics_process(delta: float) -> void:
	if explode_ttl > 0:
		explode_ttl -= 1 * delta
		if explode_ttl <= 0:
			$collider.set_deferred("disabled", true)
	
func kill_fall():
	queue_free()
	
func flyaway(dir):
	impulse_force = Global.pick_random([250, 210, 260, 200])
	var direction = Vector2(randf_range(-1, 1), -1).normalized()
	apply_impulse(direction * impulse_force)
	explode_ttl = 0.3

func explode():
	impulse_force = Global.pick_random([250, 210, 260, 200])
	var direction = Vector2(randf_range(-1, 1), -1).normalized()
	apply_impulse(direction * impulse_force)

func super_jump():
	impulse_force = Global.pick_random([250, 210, 260, 200])
	var direction = Vector2(randf_range(-1, 1), -1).normalized()
	apply_impulse(direction * impulse_force)
