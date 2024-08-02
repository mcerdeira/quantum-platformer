extends Node3D
var textures = [
	load("res://sprites/qr/artifact_parts1.png"),
	load("res://sprites/qr/artifact_parts2.png"),
	load("res://sprites/qr/artifact_parts3.png"),
	load("res://sprites/qr/artifact_parts4.png")
]

func _ready():
	get_tree().paused = true
	var material = $MeshInstance3D.get_active_material(0)
	material.albedo_texture = textures[0]

func _physics_process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().paused = false
		queue_free()
