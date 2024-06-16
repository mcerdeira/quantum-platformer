extends Node2D
@export var start_on = true

func _ready():
	if !start_on:
		$plat/AnimationPlayer.advance(6)
