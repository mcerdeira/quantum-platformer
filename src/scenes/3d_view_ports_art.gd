extends SubViewport

func _ready():
	for i in range(1, 5):
		if Global.ARTIFACT_PER_LEVEL[i]:
			set_stuff(i)
		else:
			disable_me(i)
			
func evaluateCombi():
	#1: 0
	#2: 90
	#3: 270
	#4: 180
	
	Global.combinatoryOK = false
	var okcount = 0
	var rota = [-1, 0, 90, 270, 180]
	for i in range(1, 5):
		var art = get_node("Node3D/art3d_part" + str(i))
		if art.visible and art.rotation_degrees.y == rota[i]:
			okcount+= 1
			
	if okcount >= 4:
		Global.combinatoryOK = true
		Global.play_sound(Global.CombinationOKSFX)
		
func rotationOK(r, n):
	return true
	#var node = get_node("Node3D/art3d_part" + str(n))
	#var rot = node.rotation_degrees.y + (90 * r)
	#if rot < 360 and rot >= 0:
		#return true
	#else:
		#return false

func rotation_set(r, n):
	var node = get_node("Node3D/art3d_part" + str(n))
	if node.visible:
		Global.play_sound(Global.PropSFX)
	return node.rotation_set(r)
	
func disable_me(n):
	var node = get_node("Node3D/art3d_part" + str(n))
	node.visible = false

func set_stuff(n):
	var node = get_node("Node3D/art3d_part" + str(n))
	node.part_n = n
	var material = node.get_active_material(0)
	material.albedo_texture = load("res://sprites/qr/artifact_parts"+str(n)+".png")
