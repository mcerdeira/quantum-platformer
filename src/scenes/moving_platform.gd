extends Node2D
@export var start_on = true

func _ready():
	if !start_on:
		$plat/AnimationPlayer.advance(6)

func _physics_process(delta):
	$plat/AnimationPlayer.speed_scale = Global.time_speed
