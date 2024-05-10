extends StaticBody2D

func _ready():
	Global.level_doors.append(self) 

func open():
	$CollisionShape2D.set_deferred("disabled", true)
	visible = false
	emits()
	
func close():
	$CollisionShape2D.set_deferred("disabled", false)
	visible = true
	emits()
	
func emits():
	var childs = get_children()
	for c in childs:
		Global.emit(c.global_position, 3)
