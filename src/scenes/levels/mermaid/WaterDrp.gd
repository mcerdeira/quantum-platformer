extends Node2D


func _on_sprite_animation_finished():
	visible = false
	queue_free()
