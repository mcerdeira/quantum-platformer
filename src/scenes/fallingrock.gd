extends Node2D
var fall = false
var enemy = null
@export var petface : Node2D = null

func _on_area_area_entered(area: Area2D) -> void:
	if !fall and area and area.is_in_group("boss_persecution"):
		fall = true
		enemy = area
		$AnimationPlayer.play("new_animation")
		
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
		Global.shaker_obj.shake(12, 3.5)
		enemy.die()
		enemy.global_position.x = global_position.x
		#Cosas para finalizar el nivel
		Global.ARTIFACT_PER_LEVEL[Global.TerminalNumber] = true
		Global.LEAF_STATUS = false
		Global.TOMB_STATUS = false
		Global.MERMAID_STATUS = false
		Global.SALAMANDER_STATUS = false
		Global.FromPipe = false
		Global.gotoBOSS = false
		Global.BOSS_DEAD = true
		Global.FromLastBoss = true
		petface.is_started = false
		Music.stop()
		Ambience.play(Global.FallingAmbienceSFX)
		Global.player_obj.show_message_custom("NOOO!! PEPITO!!!!", 2.0)
		await get_tree().create_timer(2.0).timeout
		Global.player_obj.show_message_custom("...", 2.0)
		await get_tree().create_timer(2.0).timeout
		Global.player_obj.show_message_custom("Tengo que ver como salir de aca...", 2.0)
		await get_tree().create_timer(2.0).timeout
		Global.scene_next(Global.TerminalNumber, false, false, false, true)
