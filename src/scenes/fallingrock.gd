extends Node2D
var fall = false

func _on_area_area_entered(area: Area2D) -> void:
	if !fall and area and area.is_in_group("boss_persecution"):
		fall = true
		Global.shaker_obj.shake(12, 3.5)
		area.die()
