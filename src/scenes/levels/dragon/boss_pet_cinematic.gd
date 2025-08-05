extends Node2D
var actived = false
var persecution = false
var messages = [
	"¡¡PEPITO!!",
	"¿QUE TE PASO? ¿ESTAS BIEN?",
	"...",
	"¿POR QUE NO VENIAS CUANDO TE LLAME?",
	"...",
	"(¿que le pasa?)",
	"...",
	"PEPITO...",
	"¿PEPITO?",
	"¡¡PEPITO!!",
	"¡¡¡¡ P E P I T O !!!!",
]
var cursor = 0

func _ready() -> void:
	if Global.AlreadySEEN:
		cursor = 8

func _physics_process(delta: float) -> void:
	if actived and !persecution:
		Global.player_obj.idle_time = 0

func _on_area_body_entered(body: Node2D) -> void:
	if !actived and body and body.is_in_group("players"):
		body.locked_ctrls = true
		body.velocity.x = 0
		body.lookleft()
		actived = true
		$Timer.start()

func _on_timer_timeout() -> void:
	if !persecution:
		Global.player_obj.show_message_custom(messages[cursor], 2.0)
		cursor += 1
		if cursor == messages.size():
			$Timer.stop()
			persecution = true
			$pet_face.started()
			Music.stop()
			Music.play(Global.BossTheme)
