extends TileMap

func _ready():
	visible = false
	get_node("../Tank").visible = false
	get_node("../Tank2").visible = false
	get_node("../lbl_angle").visible = false
	get_node("../lbl_velocity").visible = false
	get_node("../lbl_score").visible = false
	get_node("../lbl_high_score").visible = false

func start():
	visible = true
	get_node("../Tank").visible = true
	get_node("../Tank2").visible = true
	get_node("../lbl_angle").visible = true
	get_node("../lbl_velocity").visible = true
	get_node("../lbl_score").visible = true
	get_node("../lbl_high_score").visible = true
