extends Area2D
var tt_total = 1
var master_parent = null

func _ready():
	add_to_group("fireballholder")
	
func _physics_process(delta):
	if tt_total >= 0:
		tt_total -= 1 * delta
		if tt_total <= 0:
			queue_free()
