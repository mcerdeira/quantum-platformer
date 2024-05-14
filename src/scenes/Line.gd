extends  Line2D
var landed = false 
var previus_velocity = Vector2.ZERO
var gravity = 10.0
var blowed = 0
var friction = 0.1

func _ready():
	set_as_top_level(true)
		
func update_trayectory(char, direction):
	var max_points = 500
	char.velocity = direction
	clear_points()
	for i in max_points:
		add_point(char.global_position)
		if !char.is_on_floor():
			landed = false
			char.velocity.y += gravity
			if char.is_on_wall():
				char.velocity.x = (previus_velocity.x / 2) * -1
			else:
				previus_velocity = char.velocity
			
		else:
			if !char.is_on_floor():
				char.velocity.x = lerp(char.velocity.x, 0.0, friction / 10)
			else:
				char.velocity.x = lerp(char.velocity.x, 0.0, friction)
			
			landed = true
		
		char.move_and_slide()
