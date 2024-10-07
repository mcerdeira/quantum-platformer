extends CanvasLayer
var close_req = false

func _ready():
	visible = false
	Global.video_tutorial = self
	
func _physics_process(delta):
	if visible:
		if Input.is_action_just_pressed("quit"):
			close_req = true
			$AnimationPlayer.play_backwards("new_animation")

func play(current_itenm):
	if current_itenm.tutorial:
		$lbl_item.text = current_itenm.tutorial
		$AnimationPlayer.play("new_animation")
		visible = true
		Music.pause()
		Ambience.pause()
		get_tree().paused = true
		$VideoStreamPlayer.visible = true
		$VideoStreamPlayer.stream = Global.video_tutorials[current_itenm.tutorial_idx]
		$VideoStreamPlayer.play()

func _on_animation_player_animation_finished(anim_name):
	if close_req:
		$VideoStreamPlayer.stop()
		Music.resume()
		Ambience.resume()
		close_req = false
		get_tree().paused = false
		visible = false
