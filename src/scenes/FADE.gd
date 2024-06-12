extends ColorRect

func _ready():
	Global.Fader = self

func fade_in():
	$AnimationPlayer.play_backwards("new_animation")
	
	
func fade_out():
	$AnimationPlayer.play("new_animation")
