extends Area2D
var ttl = 0.0
var active = true
@export var boss_obj : Area2D = null

func _physics_process(delta):
	if active and Global.player_obj and is_instance_valid(Global.player_obj):
		if ttl > 0:
			ttl -= 1 * delta
			return
			
		var get_overlapping_areas = get_overlapping_areas()
		var player_dir = Global.player_obj.direction
		for area in get_overlapping_areas:
			if area and area.is_in_group("hammer_" + player_dir):
				if Input.is_action_pressed("shoot"):
					Global.emit(global_position, 2)
					$tomb.frame += 1
					Global.play_sound(Global.TombHitSFX)
					Global.emit(Global.pick_random([$Marker2D.global_position, $Marker2D2.global_position]), 3)
					ttl = 0.7
					if $tomb.frame >= 4:
						boss_obj.hit()
						Global.play_sound(Global.TombBrokeSFX)
						Global.emit($Marker2D.global_position, 10)
						Global.emit($Marker2D2.global_position, 10)
						$tomb.frame = 4
						active = false