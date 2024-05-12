extends StaticBody2D
@onready var draw_surface : paint = get_node("/root/Main/Surface")

func _ready():
	add_to_group("movebable")
	Global.level_doors.append(self) 

func open():
	$CollisionShape2D.set_deferred("disabled", true)
	visible = false
	draw_surface.clear_temps()
	emits()
	
func close():
	$CollisionShape2D.set_deferred("disabled", false)
	visible = true
	draw_surface.clear_temps()
	emits()
	
func emits():
	var childs = get_children()
	for c in childs:
		Global.emit(c.global_position, 3)
