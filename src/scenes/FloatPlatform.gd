extends StaticBody2D
@export var watergen : Marker2D = null
var started = false
var buoyancy_offset: float = 50.0
var shape = RectangleShape2D.new()

func _ready():
	shape.size = Vector2(96, 32)  # Tamaño del rectángulo

func _physics_process(delta):
	check_collision_with_bodies(global_position)

func check_collision_with_bodies(area_position: Vector2):
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
				water = true
				break
				#print("Colisión con: ", collider.name)
	
	if water:
		global_position.y -= 0.1
	else:
		global_position.y += 0.1
	
	queue_redraw()
		
func _draw():
	var color = Color(1, 0, 0, 1)  # Rojo transparente
	draw_rect(Rect2(-shape.size / 2, shape.size), color, true)
		
#func _physics_process(delta):
	#if started:
		#var water_level = 0
		#var total_y = 0.0
		#var count = 0
#
		## Usar posiciones almacenadas para calcular la altura del agua
		#for pos in watergen.water_positions:
			#var p = to_global(pos) 
			#total_y += p.y
			#count += 1
	#
		#if count > 0:
			#water_level = total_y / count - buoyancy_offset
		#
		##global_position.y = lerp(global_position.y, water_level, 0.1)
#
		#print(water_level-watergen.global_position.y)
#
	#
#func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	#if !body:
		#started = true  
