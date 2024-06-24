extends Node2D
var killme = false
var waterdrop = load("res://scenes/water_drop_spawn.tscn")

func _ready():
	if randi() % 3 == 0:
		queue_free()
	else:
		if randi() % 3 == 0:
			killme = true
		else:
			queue_free()

func _physics_process(delta):
	if killme:
		var p = waterdrop.instantiate()
		var parent = get_parent()
		p.position = Vector2(position.x, position.y - 6)
		parent.add_child(p)
		queue_free()
		return
