extends Area2D
var active = false
var dead = false
var TOTAL_LIFE = 5.0
var LIFE = TOTAL_LIFE
var idx = 0
var current_anim = null
var ttl = 2
var epilepsy_mode = false
var num_bullets = 4
var bullets_pos = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
const FireBallHolderShoot = preload("res://scenes/FireBallHolderShoot.tscn")
@export var pos : Array[Marker2D]
@export var Anim : AnimationPlayer

func _ready():
	$boss_enemy_2/GhostBossLaugh.visible = false
	Global.BULLETS_MOVE = true
	visible = false
	await get_tree().create_timer(2.3).timeout
	visible = true
	await get_tree().create_timer(1.2).timeout
	$boss_enemy_2/GhostBossLaugh.visible = true
	Global.play_sound(Global.GhostBossLaughSFX)
	$AnimationPlayer.play("new_animation")
	current_anim = Anim.get_animation("new_animation")
	current_anim.track_set_enabled(2, false)
	current_anim.track_set_enabled(3, false)
	
	$Timer.start()
	
func shoot():
	Global.shaker_obj.shake(3, 2.1)
	for i in range(num_bullets):
		var p = FireBallHolderShoot.instantiate()
		var parent = get_parent()
		p.global_position = global_position
		p.direction = bullets_pos[i]
		parent.add_child(p)
		Global.emit(global_position, 15)
	
func _physics_process(delta):
	if active:
		LIFE -= 0.1 * delta
		if LIFE <= 0:
			LIFE = 0
			
		Global.boss_bar.calc_life_bar(TOTAL_LIFE, LIFE)
		if Global.player_obj:
			if global_position.x > Global.player_obj.global_position.x:
				$boss_enemy_2.scale.x = -1
			else:
				$boss_enemy_2.scale.x = 1
			
		if !epilepsy_mode and LIFE <= 3.0:
			ttl -= 1 * delta
			if ttl <= 0:
				if Anim.current_animation_position >= 3.81:
					epilepsy_mode = true
					current_anim.track_set_enabled(2, true)
					current_anim.track_set_enabled(3, true)

func position():
	if Global.BULLETS_MOVE:
		$boss_enemy_2.animation = "invisible"
	else:	
		$boss_enemy_2.animation = "default"
		
	Global.BULLETS_MOVE = !Global.BULLETS_MOVE
	#global_position = pos[idx].global_position
	#idx += 1
	#if idx > pos.size() - 1:
		#idx = 0
	
func activate():
	$boss_enemy_2/GhostBossLaugh.visible = false
	Ambience.stop()
	Music.stop()
	Anim.play("new_animation")
	visible = true
	active = true
	Global.boss_bar.showme()

func _on_timer_timeout():
	activate()
