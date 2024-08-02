extends Node3D
var active_number = 1
var textures = [
	load("res://sprites/qr/artifact_parts1.png"),
	load("res://sprites/qr/artifact_parts2.png"),
	load("res://sprites/qr/artifact_parts3.png"),
	load("res://sprites/qr/artifact_parts4.png")
]

func _ready():
	get_tree().paused = true
	var material
	for i in range(4):
		var mesh = get_node("art3d_part" + str(i+1))
		material = mesh.get_active_material(0)
		material.albedo_texture = textures[i]
	
func _physics_process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().paused = false
		queue_free()
		if Input.is_action_just_pressed("shoot") or Input.is_action_just_pressed("jump"):
			active_number += 1
			if active_number > 4:
				active_number = 1
