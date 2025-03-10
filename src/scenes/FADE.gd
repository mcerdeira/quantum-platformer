extends ColorRect

func _ready():
	visible = true
	Global.fade_finished = false
	Global.Fader = self

func fade_in():
	$AnimationPlayer.play_backwards("new_animation")
	
func fade_out():
	$AnimationPlayer.play("new_animation")

func _on_animation_player_animation_finished(_anim_name):
	Global.fade_finished = true
	if !Global.TunnelTerminalNumber:
		if Global.OverWorldFromGameOver:
			Global.player_obj.show_message_death()
		elif Global.FromBonus:
			Global.player_obj.show_message_bonus()
