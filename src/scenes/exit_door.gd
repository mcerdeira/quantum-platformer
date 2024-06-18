extends Area2D
var closed = true
var nope = false
var target = null
@export var terminal_number = -1

func _ready():
	if terminal_number == -1:
		if !nope:
			Global.exit_door = self
	else:
		if Global.TerminalDoors[terminal_number]:
			open()
		
func _physics_process(delta):
	if !closed and target:
		target.hide_eyes()
		target.global_position = global_position
		target.modulate.a -= 2 * delta
		if target.modulate.a <= 0:
			Global.scene_next(terminal_number)

func open():
	closed = false
	$sprite.frame = 1

func _on_body_entered(body):
	if !closed and body.is_in_group("players"):
		target = body
