extends Node2D
var score = 0
var tries = 0 
var score_mult = [0, 500, 200, 100, 10, 5]
var game_ended = false

func _ready():
	update_score()

func rotation_update(rot):
	$lbl_angle.text = "ANGLE: " + str(abs(round(rad_to_deg(rot))))
	
func speed_update(sp):
	$lbl_velocity.text = "SPEED: " + str(round(sp))
	
func shoot():
	tries += 1
	
func _physics_process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().change_scene_to_file("res://scenes/main.tscn")	
	
	if game_ended:
		if Input.is_action_pressed("restart"):
			get_tree().reload_current_scene()
	
func update_score():
	$lbl_score.text = "SCORE: " + str(score)
	$lbl_high_score.text = "HIGH: " + str(Global.retro_game_high_score)

func win():
	if !game_ended:
		game_ended = true
		if tries <= score_mult.size() - 1: 
			score += score_mult[tries]
		else:
			score += 3
		
		if score > Global.retro_game_high_score:
			Global.retro_game_high_score = score
		
		$lbl_result.text = "YOU WIN!!"
		$lbl_result.visible = true
		$result_color.visible = true
		update_score()
		Global.save_game()
	
func lose():
	if !game_ended:
		game_ended = true
		score = 0
		$lbl_result.text = "GAME OVER"
		$lbl_result.visible = true
		$result_color.visible = true
		update_score()
		Global.save_game()
