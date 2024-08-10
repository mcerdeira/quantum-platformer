extends Node2D
var killme = false
var waterdrop = load("res://scenes/water_drop_spawn.tscn")
@export var fixed = false 

func _ready():
	if Global.TerminalNumber == 3:
		killme = true
	else:
		if !fixed:
			if randi() % 3 == 0:
				queue_free()
			else:
				if randi() % 3 == 0:
					killme = true

func _physics_process(_delta):
	if killme:
		var p = waterdrop.instantiate()
		var parent = get_parent()
		p.position = Vector2(position.x, position.y - 6)
		parent.add_child(p)
		queue_free()
		return
