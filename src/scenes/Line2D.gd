extends Line2D

var max_len = 100
@onready var parent = get_parent()

func _ready():
	set_as_top_level(true)
	remove_point(0)

func _process(delta):
	if get_point_count() < max_len:
		add_point(parent.global_position)
	
		
