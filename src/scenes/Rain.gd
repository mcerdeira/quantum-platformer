extends Node2D
var manual_thunders = false

func _physics_process(delta: float) -> void:
	if Global.global_camera.enabled:
		visible = false
	else:
		visible = true

func _on_timer_timeout():
	if !manual_thunders:
		$AnimationPlayer.play("new_animation")
		Global.play_sound(Global.ThunderSFX)
		$Timer.wait_time = Global.pick_random([10, 15, 20, 6])
	else:
		$Timer.stop()

func force_thunder():
	$AnimationPlayer.play("new_animation")
	Global.play_sound(Global.ThunderSFX)
