extends Node2D
var buf = 40
var configs = [
	[null],
	[Vector2(0, 0)],
	[Vector2(0, 0), Vector2(40, 0)],
	[Vector2(0, 0), Vector2(40, 0), Vector2(-40, 0)],
	[Vector2(0, 0), Vector2(40, 0), Vector2(80, 0), Vector2(-40, 0)],
	[Vector2(0, 0), Vector2(40, 0), Vector2(80, 0), Vector2(120, 0), Vector2(-40, 0)],
	[Vector2(0, 0), Vector2(40, 0), Vector2(80, 0), Vector2(120, 0), Vector2(-80, 0), Vector2(-40, 0)],
	[Vector2(0, 0), Vector2(40, 0), Vector2(80, 0), Vector2(120, 0), Vector2(-120, 0), Vector2(-80, 0), Vector2(-40, 0)]
]

func refresh_item():
	var count = 0
	for i in range(Global.gunz_equiped.size()):  
		if Global.gunz_equiped[i].name != "none":
			count += 1
			
	for i in range(0, Global.gunz_equiped.size()):
		var gslot = get_node("gun_slot" + str(i))
		if Global.gunz_equiped[i].name != "none":
			gslot.animation = Global.gunz_equiped[i].name

	if count == 1:
		$gun_slot0.visible = true
		$gun_slot0.position = configs[count][0]
	elif count == 2:
		$gun_slot0.visible = true
		$gun_slot1.visible = true
		$gun_slot0.position = configs[count][0]
		$gun_slot1.position = configs[count][1]
	elif count == 3:
		$gun_slot0.visible = true
		$gun_slot1.visible = true
		$gun_slot2.visible = true
		$gun_slot0.position = configs[count][0]
		$gun_slot1.position = configs[count][1]
		$gun_slot2.position = configs[count][2]
	elif count == 4:
		$gun_slot0.visible = true
		$gun_slot1.visible = true
		$gun_slot2.visible = true
		$gun_slot3.visible = true
		$gun_slot0.position = configs[count][0]
		$gun_slot1.position = configs[count][1]
		$gun_slot2.position = configs[count][2]
		$gun_slot3.position = configs[count][3]
	elif count == 5:
		$gun_slot0.visible = true
		$gun_slot1.visible = true
		$gun_slot2.visible = true
		$gun_slot3.visible = true
		$gun_slot4.visible = true
		$gun_slot0.position = configs[count][0]
		$gun_slot1.position = configs[count][1]
		$gun_slot2.position = configs[count][2]
		$gun_slot3.position = configs[count][3]
		$gun_slot4.position = configs[count][4]
	elif count == 6:
		$gun_slot0.visible = true
		$gun_slot1.visible = true
		$gun_slot2.visible = true
		$gun_slot3.visible = true
		$gun_slot4.visible = true
		$gun_slot5.visible = true
		
		$gun_slot0.position = configs[count][0]
		$gun_slot1.position = configs[count][1]
		$gun_slot2.position = configs[count][2]
		$gun_slot3.position = configs[count][3]
		$gun_slot4.position = configs[count][4]
		$gun_slot5.position = configs[count][5]
		
	elif count == 7:
		$gun_slot0.visible = true
		$gun_slot1.visible = true
		$gun_slot2.visible = true
		$gun_slot3.visible = true
		$gun_slot4.visible = true
		$gun_slot5.visible = true
		$gun_slot6.visible = true
		
		$gun_slot0.position = configs[count][0]
		$gun_slot1.position = configs[count][1]
		$gun_slot2.position = configs[count][2]
		$gun_slot3.position = configs[count][3]
		$gun_slot4.position = configs[count][4]
		$gun_slot5.position = configs[count][5]
		$gun_slot6.position = configs[count][6]
