extends Node2D
var oneshot = true
@export var multi = 1

func _ready() -> void:
	visible = false

func _on_area_entered(area: Area2D) -> void:
	if oneshot and area and area.is_in_group("boss_persecution"):
		if multi == 1:
			area.boost_speed(1.5)
		else:
			area.boost_speed(0.5)
		oneshot = false
