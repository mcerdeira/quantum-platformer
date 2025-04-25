extends Node2D
var SPEED = 200
var destination = null

func _process(delta: float) -> void:
	if visible:
		rotation_degrees += SPEED * delta
		global_position += global_position.direction_to(destination) * SPEED * delta
		if global_position.distance_to(destination) <= 5:
			scale.x -= SPEED * delta
			scale.y = scale.x
			if scale.x <= 0:
				scale.x = 0
				scale.y = 0
				Global.scene_next()
