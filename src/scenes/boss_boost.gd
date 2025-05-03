extends Node2D
var oneshot = true

func _ready() -> void:
	visible = false

func _on_area_entered(area: Area2D) -> void:
	if oneshot and area and area.is_in_group("boss_persecution"):
		area.speed *= 1.5
		oneshot = false
