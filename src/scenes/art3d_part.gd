extends MeshInstance3D
var part_n = 0
var _speed = 1.0

func _physics_process(delta: float) -> void:
	print(str(part_n) + ": " + str(rotation_degrees.y))

func rotation_set(r):
	var rot = rotation_degrees.y + (90 * r)
	var _tween = create_tween()
	_tween.set_trans(Tween.TRANS_QUINT)
	_tween.set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(self, "rotation_degrees:y", rot, _speed)
	return _tween
