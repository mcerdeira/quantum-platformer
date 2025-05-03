extends Area2D
var oneshot = true

func _ready() -> void:
	visible = false

func _on_area_entered(area: Area2D) -> void:
	if oneshot and area and area.is_in_group("boss_persecution"):
		area.scale.y *= -1
		oneshot = false
