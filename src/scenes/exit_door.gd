extends Area2D
var closed = true
var nope = false

func _ready():
	if !nope:
		Global.exit_door = self

func open():
	closed = false
	$sprite.frame = 1
