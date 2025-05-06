extends Node2D
var fall = false
var enemy = null

func _on_area_area_entered(area: Area2D) -> void:
	if !fall and area and area.is_in_group("boss_persecution"):
		fall = true
		enemy = area
		$AnimationPlayer.play("new_animation")
		
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
		Global.shaker_obj.shake(12, 3.5)
		enemy.die()
		enemy.global_position.x = global_position.x
