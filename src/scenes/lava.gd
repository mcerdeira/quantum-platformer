extends Node2D
var limit = 320
var val = 0.0
var temp = 0.0
var upper_limit = 0.09
var upper_limit_temp = 1.0
var first_time = true
var fog = preload("res://scenes/Fog.tscn")

func _physics_process(_delta):
	if Global.TerminalNumber <= Global.TerminalsEnum.EYE:
		if first_time:
			first_time = false
			Global.lava_FX.set_intensity(0.0, 0.0)
			queue_free()
	elif Global.TerminalNumber == Global.TerminalsEnum.SALAMANDER:
		if first_time:
			first_time = false
			if !Global.BOSS_ROOM:
				Global.lava_FX.set_intensity(0.089, 0.9)
			else:
				Global.lava_FX.set_intensity(0.0, 0.0)
				queue_free()
	elif Global.TerminalNumber == Global.TerminalsEnum.MERMAID:
		if first_time:
			first_time = false
			Global.lava_FX.set_intensity(0.0, 0.0)
			if $TileMap:
				$TileMap.queue_free()
	elif Global.TerminalNumber == Global.TerminalsEnum.TOMB:
		if first_time:
			if !Global.TunnelTerminalNumber and Global.CurrentState == Global.GameStates.RANDOMLEVEL:
				var f = fog.instantiate()
				get_parent().add_child(f)
			first_time = false
			Global.lava_FX.set_intensity(0.0, 0.0)
			if $TileMap:
				$TileMap.queue_free()
	else:
		if Global.player_obj != null:
			var faked = Vector2(global_position.x, Global.player_obj.global_position.y)
			var dist = global_position.distance_to(faked) 
			var calc_val = 0.0
			var calc_temp = 0.0
			if abs(dist) < limit:
				calc_val = lerp(val, upper_limit, 0.05)
				calc_temp = lerp(temp, upper_limit_temp, 0.05)
			else:
				calc_val = lerp(val, 0.0, 0.05)
				calc_temp = lerp(temp, 0.0, 0.05)
				
			if calc_val != val or calc_temp != temp:
				val = calc_val
				temp = calc_temp
				Global.lava_FX.set_intensity(val, temp)
			
