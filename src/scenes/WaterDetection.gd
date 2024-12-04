extends Area2D

@export var push_force: float = 50.0  # La fuerza con la que el personaje empuja las partículas

func _physics_process(delta):
	# Detectar cuerpos en el área
	var overlapping_bodies = get_overlapping_bodies()
	for body in overlapping_bodies:
		if PhysicsServer2D.body_get_mode(body) == PhysicsServer2D.BODY_MODE_RIGID:
			# Calcular dirección del empuje
			var body_position = body.global_position
			var direction = (body_position - global_position).normalized()
			
			# Aplicar fuerza a la partícula
			var impulse = direction * push_force
			PhysicsServer2D.body_apply_impulse(body, Vector2.ZERO, impulse)
