extends StaticBody2D
@export var color = "blue"

func _ready():
	add_to_group("redblue_switch")
	$sprite.animation = color
	if Global.SwitchColorActive == color:
		close(color)
	else:
		open(color)

func open(_color):
	if _color == color:
		$sprite.frame = 1
		$collider.set_deferred("disabled", true)
	
func close(_close):
	if _close == color:
		$sprite.frame = 0
		$collider.set_deferred("disabled", false)
