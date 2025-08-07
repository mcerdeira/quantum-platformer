extends Node2D

func start():
	visible = true
	$AnimationPlayer.play("new_animation")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	await get_tree().create_timer(5.0).timeout
	Global.ARTIFACT_PER_LEVEL = [false, false, false, false, false]
	Global.perks_equiped = [null, null, null, null, null, null, null]
	Global.CurrentLevel = 0
	Global.Gold = 0
	Global.GoldDonation = 0
	Global.first_time = true
	Global.FirstDeath = true
	Global.erase_game()
	Global.init_game()
	Global.CurrentState = Global.GameStates.TITLE
	get_tree().reload_current_scene()
