extends Area2D
var following = false
var follower = null
var speed_total = 200
var speed = speed_total
@export var point_interval := 0.1  # cada cuántos segundos se agrega un punto
@export var max_points := 150  # largo máximo de la cola

var time_accumulator := 0.0
@export var line: Line2D

func add_tail_point():
	line.add_point(global_position)
	if line.points.size() > max_points:
		line.remove_point(0)

func _ready() -> void:
	add_to_group("boss_persecution")
	visible = false
	follower = get_parent()

func _physics_process(delta: float) -> void:
	if following:
		time_accumulator += delta
		if time_accumulator >= point_interval:
			time_accumulator = 0.0
			add_tail_point()
		
		if speed > speed_total:
			speed -= 10 * delta
			if speed <= speed_total:
				speed = speed_total
	
		follower.progress += speed * delta

func _on_activator_body_entered(body: Node2D) -> void:
	if $"../../../boss".persecution:
		if body and body.is_in_group("players"):
			if !visible:
				following = true
				visible = true
				$"../../../boss".visible = false
				
func _on_body_entered(body: Node2D) -> void:
	if visible:
		if body and body.is_in_group("players"):
			speed = 0
			body.kill()
