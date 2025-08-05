extends Area2D
var following = false
var follower = null
var speed_total = 195
var speed = speed_total
var dead = false
var speedo_ttl = 3.0
var changui_count = 3
const blood = preload("res://scenes/blood.tscn")
@export var point_interval = 0.02  # cada cuántos segundos se agrega un punto
@export var max_points = 550  # largo máximo de la cola

var time_accumulator = 0.0
@export var line: Line2D

func add_tail_point():
	line.add_point(global_position)
	if line.points.size() > max_points:
		line.remove_point(0)

func _ready() -> void:
	add_to_group("boss_persecution")
	visible = false
	follower = get_parent()
	
func force_kill():
	Global.player_obj.global_position = Vector2(1424, 310)
	follower.progress_ratio = 0.99
	await get_tree().create_timer(2).timeout
	activation()
	
func die():
	dead = true
	$sprite.animation = "dead"
	bleed(145)
	await get_tree().create_timer(2).timeout
	bleed(125)
	
func bleed(count):
	Global.play_sound(Global.PlayerBleedSFX)
	for i in range(count):
		var blood_instance : Area2D = blood.instantiate()
		blood_instance.global_position = global_position
		get_parent().call_deferred("add_child", blood_instance)

func _physics_process(delta: float) -> void:
	if speedo_ttl > 0:
		speedo_ttl -= 1 * delta
		if speedo_ttl <= 0:
			speedo_ttl = 0
	
	if dead:
		speed = 0
	else:
		if following:
			time_accumulator += delta
			if time_accumulator >= point_interval:
				time_accumulator = 0.0
				add_tail_point()
			
			if speed > speed_total:
				speed -= 20 * delta
				if speed <= speed_total:
					speed = speed_total
					
			if speed < speed_total:
				speed += 20 * delta
				if speed >= speed_total:
					speed = speed_total
					
			follower.progress += speed * delta

func _on_activator_body_entered(body: Node2D) -> void:
	if !dead:
		if $"../../../boss".persecution:
			if body and body.is_in_group("players"):
				activation()
				
func activation():
	if !visible:
		growl()
		following = true
		visible = true
		$"../../../boss".visible = false
				
func _on_body_entered(body: Node2D) -> void:
	if !dead:
		if visible:
			if body and body.is_in_group("players"):
				speed = 0
				body.kill()

func _on_sound_area_body_entered(body: Node2D) -> void:
	if !dead and visible:
		if body and body.is_in_group("players"):
			changui_count -= 1
			growl()
			if changui_count > 0:
				boost_speed(0.7)
			
func boost_speed(mult):
	speed *= mult
			
func _on_visible_notifier_screen_exited() -> void:
	if !dead and visible:
		if speedo_ttl <= 0:
			speedo_ttl = 3.0
			growl()
			if global_position.distance_to(Global.player_obj.global_position) > 50:
				boost_speed(1.7)

func growl():
	var options = {"pitch_scale": Global.pick_random([1, 0.9, 0.8])}
	Global.play_sound(Global.PersecutionBossSFX, options)
