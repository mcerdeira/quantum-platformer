extends Node2D
var forceitem = -1

func _ready():
	add_to_group("item_3d")
	Global.play_sound(Global.Item3DSFX)
	Global.PauseStop = true
	get_tree().paused = true
	var material = $SubViewport/Node3D/MeshInstance3D.get_active_material(0)
	if forceitem == -1:
		forceitem = Global.TerminalNumber
	material.albedo_texture = load("res://sprites/qr/artifact_parts"+str(forceitem)+".png")

func _physics_process(_delta):
	if Input.is_action_just_pressed("quit") or Input.is_action_just_pressed("start") or Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("shoot") or Input.is_action_just_pressed("quit_soft"):
		get_tree().paused = false
		queue_free()
