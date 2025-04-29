extends Node2D
var tunnel_obj = load("res://scenes/levels/tunnel.tscn")
@export var fake_player : Node2D

func _physics_process(delta: float) -> void:
	if fake_player:
		if Global.player_obj and is_instance_valid(Global.player_obj):
			if global_position.distance_to(Global.player_obj.global_position) <= 850:
				Global.shaker_obj.shake(15, 3)
			elif global_position.distance_to(Global.player_obj.global_position) <= 1200:
				Global.shaker_obj.shake(5, 3)

func _ready() -> void:
	var calc_depth = 1.0
	var color = 1.0 
	var rspeed = 10.0
	var index = 0
	for i in range(25):
		var tunnel_i = tunnel_obj.instantiate()
		
		calc_depth -= 0.05
		color -= 0.06
		rspeed -= 1.0
		index -= 1
		
		tunnel_i.scale.x = calc_depth
		tunnel_i.scale.y = calc_depth
		tunnel_i.rotate_speed = rspeed
		tunnel_i.z_index = index
		
		tunnel_i.modulate = Color(color, color, color, 1)
		
		add_child(tunnel_i)
		
		tunnel_i.position = Vector2(0, 0)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body and body.is_in_group("players"):
		body.locked_ctrls = true
		body.visible = false
		fake_player.destination = global_position
		fake_player.global_position = body.global_position
		fake_player.visible = true
