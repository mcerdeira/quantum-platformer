extends Area2D
var direction = 1
var speed = 50.0
var attacking = false
var idle_pos = 150
var attack_pos = 24

func _ready() -> void:
	if Global.TerminalNumber != Global.TerminalsEnum.MERMAID:
		visible = false
		queue_free() 

func _physics_process(delta: float) -> void:
	var diffx = null
	if Global.player_obj != null and is_instance_valid(Global.player_obj):
		diffx = abs(abs(Global.player_obj.global_position.x) - abs(global_position.x))
	if attacking:
		speed = lerp(speed, 100.0, 0.3)
		if diffx <= 1:
			$collider.position.y = attack_pos
			$sprite.animation = "attacking"
			$sprite.play()
	else:
		if diffx and diffx > 1200:
			speed = lerp(speed, 500.0, 0.5)
		else:
			speed = lerp(speed, 50.0, 0.5)
	
	position.x += speed * direction * delta
	if global_position.x <= -408 and direction == -1:
		direction = 1
		$sprite.scale.x = 1
	if global_position.x >= 4608 and direction == 1: 
		direction = -1
		$sprite.scale.x = -1

func _on_radar_body_entered(body: Node2D) -> void:
	if !attacking and body and body.is_in_group("players"):
		attacking = true
		$Timer.start()

func _on_body_entered(body: Node2D) -> void:
	if attacking and body and body.is_in_group("players"):
		$collider.position.y = idle_pos
		attacking = false
		body.eated()
		Global.play_sound(Global.EnemyChewingSFX, {}, global_position)
		$sprite.animation = "desattacking"
		$sprite.play()

func _on_timer_timeout() -> void:
	if attacking:
		$collider.position.y = idle_pos
		attacking = false
		if $sprite.animation == "attacking":
			$sprite.animation = "desattacking"
			$sprite.play()

func _on_sprite_animation_finished() -> void:
	if $sprite.animation == "desattacking":
		$sprite.animation = "default"
