extends Node2D
var buf = 40

func refresh_item():
	var count = 0
	for i in range(Global.gunz_equiped.size()):  
		if Global.gunz_equiped[i].name != "none":
			count += 1
			
	$gun_slot0.animation = Global.gunz_equiped[Global.gunz_index].name
	print(str(Global.gunz_index) + ": " + Global.gunz_equiped[Global.gunz_index].name)
	var calculated_idx = Global.gunz_index
	
	for i in range(1, 7):
		if i != Global.gunz_index:
			var gslot = get_node("gun_slot" + str(i))
			calculated_idx += 1
			if calculated_idx > Global.gunz_index_max:
				calculated_idx = 0

			gslot.animation = Global.gunz_equiped[calculated_idx].name
			print(str(calculated_idx) + ": " + Global.gunz_equiped[calculated_idx].name)
	
	if count == 1:
		$gun_slot0.visible = true
	elif count == 2:
		$gun_slot0.visible = true
		$gun_slot1.visible = true
	elif count == 3:
		$gun_slot0.visible = true
		$gun_slot1.visible = true
		$gun_slot2.visible = true
	elif count == 4:
		$gun_slot0.visible = true
		$gun_slot1.visible = true
		$gun_slot2.visible = true
		$gun_slot3.visible = true
	elif count == 5:
		$gun_slot0.visible = true
		$gun_slot1.visible = true
		$gun_slot2.visible = true
		$gun_slot3.visible = true
		$gun_slot4.visible = true
	elif count == 6:
		$gun_slot0.visible = true
		$gun_slot1.visible = true
		$gun_slot2.visible = true
		$gun_slot3.visible = true
		$gun_slot4.visible = true
		$gun_slot5.visible = true
	elif count == 7:
		$gun_slot0.visible = true
		$gun_slot1.visible = true
		$gun_slot2.visible = true
		$gun_slot3.visible = true
		$gun_slot4.visible = true
		$gun_slot5.visible = true
		$gun_slot6.visible = true
