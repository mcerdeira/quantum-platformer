extends Area2D
var closed = true
var nope = false
var target = null
@export var terminal_number = -1
@export var gotoBOSS = true

func _ready():
	if terminal_number != -1:
		$sprite.animation = str(terminal_number)
	
	if !gotoBOSS:
		if terminal_number == -1:
			if !nope:
				Global.exit_door = self
		else:
			var change = Global.sync_this_terminal(terminal_number)
			if Global.Terminals[terminal_number].status:
				open(change)
		
func _physics_process(delta):
	if !closed and target:
		target.hide_eyes()
		target.global_position.x = global_position.x
		target.modulate.a -= 2 * delta
		if target.modulate.a <= 0:
			Global.scene_next(terminal_number, gotoBOSS)

func assign(_terminal_number):
	terminal_number = _terminal_number
	Global.exit_door = self

func open(with_sound = false):
	closed = false
	$sprite.frame = 1
	if gotoBOSS or with_sound:
		var options = {"pitch_scale": 0.7}
		Global.play_sound(Global.DoorOpensSFX, options)
		Global.shaker_obj.shake(15, 3)

func _on_body_entered(body):
	if !closed and body.is_in_group("players"):
		target = body
