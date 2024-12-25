extends StaticBody2D
var started = false
var change_ttl = 0
var shape = RectangleShape2D.new()
var goupttl = 2.0
var original_position = null

func _ready():
	shape.size = Vector2(96, 16)  # Tamaño del rectángulo
	original_position = global_position

func _physics_process(delta):
	check_collision_with_bodies(global_position, delta)

func check_collision_with_bodies(area_position: Vector2, delta):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()

	query.set_shape(shape)
	query.transform = Transform2D(0, area_position)  # Colocar el sensor en la posición deseada
	query.collide_with_bodies = true  # Detectar solo cuerpos físicos
	query.collide_with_areas = false  # No detectar otras áreas

	var results = space_state.intersect_shape(query, 32)  # Máximo 32 colisiones
	var water = false
	if results.size() > 0:
		for result in results:
			var collider = result["collider"]
			if collider == null:
				started = true
				water = true
				break
	
	if water:
		if goupttl > 0:
			goupttl -= 1 * delta 
		if goupttl <= 0:
			shape.size.x = lerp(shape.size.x, 8.0, 0.1)
			shape.size.y = lerp(shape.size.y, 8.0, 0.1)
		change_ttl = 0.2
		global_position.y -= 7 * delta
	else:
		if started:
			change_ttl -= 1 * delta
			if change_ttl <= 0:
				global_position.y += 25 * delta
				if global_position.y > original_position.y:
					global_position.y = original_position.y
				shape.size.x = lerp(shape.size.x, 96.0, 0.1)
				shape.size.y = lerp(shape.size.y, 32.0, 0.1)
	
	#queue_redraw()
		#
#func _draw():
	#var color = Color(1, 0, 0, 1)  # Rojo transparente
	#draw_rect(Rect2(-shape.size / 2, shape.size), color, true)
