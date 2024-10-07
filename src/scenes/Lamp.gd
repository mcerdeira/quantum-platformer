extends Node2D
var killme = false
var waterdrop = load("res://scenes/water_drop_spawn.tscn")
@export var fixed = false 

func _ready():
	var val = randf_range(0.75, 1.5) 
	$LampDown/LampArea/Lamp/sprite.speed_scale *= val
	$AnimationPlayer.speed_scale *= val
	if Global.TerminalNumber == Global.TerminalsEnum.MERMAID:
		killme = true
	else:
		if Global.TerminalNumber == Global.TerminalsEnum.TOMB:
			fixed = true
		
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
