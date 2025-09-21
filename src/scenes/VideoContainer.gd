extends CanvasLayer
var close_req = false

func _ready():
	visible = false
	Global.video_tutorial = self
	
func _physics_process(delta):
	if visible:
		if Input.is_action_just_pressed("quit") or Input.is_action_just_pressed("jump"):
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
			close_req = true
			$AnimationPlayer.play_backwards("new_animation")

func play(current_itenm):
	if current_itenm.tutorial:
		$lbl_item.text = current_itenm.tutorial
		$lbl_title.text = current_itenm.friendly_name
		$AnimationPlayer.play("new_animation")
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -20)
		visible = true
		get_tree().paused = true
		$VideoStreamPlayer.visible = true
		$VideoStreamPlayer.stream = Global.video_tutorials[current_itenm.tutorial_idx]
		$VideoStreamPlayer.play()

func _on_animation_player_animation_finished(anim_name):
	if close_req:
		$VideoStreamPlayer.stop()
		close_req = false
		get_tree().paused = false
		visible = false
