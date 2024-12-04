extends RigidBody2D
var infuence =1000
var stiffness = 100
func jump():
	pass

func _physics_process(delta):
	var I = infuence
	var S = stiffness 
	var P = get_parent().global_position - get_parent().global_transform.origin
	var M = mass
	var V = get_parent().velocity
	var impulse = (I*P) - (S*M*V)
	apply_central_impulse(impulse * delta)
