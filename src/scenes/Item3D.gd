extends Node3D

func _ready():
	get_tree().paused = true
	var material = $MeshInstance3D.get_active_material(0)
	material.albedo_texture = load("res://sprites/qr/artifact_parts"+str(Global.TerminalNumber)+".png")

func _physics_process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().paused = false
		queue_free()
