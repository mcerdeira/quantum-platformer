extends Node3D
var active_number = 1

func _ready():
	get_tree().paused = true
	var material
	for i in range(4):
		var mesh = get_node("art3d_part" + str(i+1))
		material = mesh.get_active_material(0)
		material.albedo_texture = load("res://sprites/qr/artifact_parts"+str(i+1)+".png")
	
func _physics_process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().paused = false
		queue_free()
	elif Input.is_action_just_pressed("down"):
		active_number += 1
		if active_number > 4:
			active_number = 1
	elif Input.is_action_just_pressed("up"):
		active_number -= 1
		if active_number < 1:
			active_number = 3
