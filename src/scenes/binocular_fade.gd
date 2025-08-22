extends ColorRect

func _ready() -> void:
	Global.BinocularFade = self

func blink():
	$AnimationPlayer.play("new_animation")
	
func _physics_process(delta: float) -> void:
	if Global.global_camera.enabled:
		if Input.is_action_just_released("zoomin"):
			if Global.CurrentState == Global.GameStates.RANDOMLEVEL:
				Global.play_sound(Global.BinocularSFX)
				Global.BinocularFade.blink()

func blonk():
	Global.global_camera.enabled = !Global.global_camera.enabled
	$"../CanvasLayer/Control".visible = !Global.global_camera.enabled
	Global.player_obj.swap_camera()
	get_tree().paused = Global.global_camera.enabled
