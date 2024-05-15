extends Area2D
var closed = true

func _ready():
	Global.exit_door = self

func open():
	closed = false
	$sprite.frame = 1
