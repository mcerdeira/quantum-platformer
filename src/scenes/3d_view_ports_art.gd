extends SubViewport

func _ready():
	for i in range(1, 5):
		if Global.ARTIFACT_PER_LEVEL[i]:
			set_stuff(i)
		else:
			disable_me(i)

func rotation_set(r, n):
	var node = get_node("Node3D/art3d_part" + str(n))
	return node.rotation_set(r)
	
func disable_me(n):
	var node = get_node("Node3D/art3d_part" + str(n))
	node.visible = false

func set_stuff(n):
	var node = get_node("Node3D/art3d_part" + str(n))
	node.part_n = n
	var material = node.get_active_material(0)
	material.albedo_texture = load("res://sprites/qr/artifact_parts"+str(n)+".png")
