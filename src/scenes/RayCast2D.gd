extends RayCast2D
var EnemyObj = null

func _ready():
	EnemyObj = get_parent().get_parent()

func _physics_process(delta):
	var c = get_collider()
	if c and c.is_in_group("players"):
		if !c.im_invisible:
			EnemyObj._on_agro_body_entered(c)
