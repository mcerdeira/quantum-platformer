extends Area2D

@export var current_item_name = ""
var current_item = null
var opened = false
var active = false
var player = null
var delay_camera = 0.2
var ttl = 0
var NO_STOCK = false
var inflation = 1.0

func _ready():
	if !Global.TOMB_STATUS and !Global.MERMAID_STATUS and !Global.SALAMANDER_STATUS and !Global.SERAPH_STATUS:
		inflation = 10.0
	
	$sprite.animation = current_item_name
	$display/back/sprite.animation = current_item_name
	current_item = Global.find_item(current_item_name)
	if Global.perks_equiped[int(current_item.idx)] != null:
		$display/back/lbl_item.text = "== AGOTADO ==" 
		$display/back/sprite.animation = "no-stock"
		$display/back/arrows.animation = "empty"
		$display/back/lbl_price.text = ""
		$display/back/Coin.visible = false
		NO_STOCK = true
	else:
		$display/back/lbl_item.text = "== " + current_item.friendly_name.to_upper() + " ==" + "\n" + current_item.description
		$display/back/lbl_price.text = str(current_item.price * inflation)

func _physics_process(delta):
	if ttl > 0:
		ttl -= 1 * delta
		return
		
	$display.visible = active
	
	if !active and opened:
		if player:
			if delay_camera > 0:
				delay_camera -= 1 * delta
				if delay_camera <= 0:
					player.dont_camera = false
	
	if active and !opened:
		$display.visible = true
		if Input.is_action_just_pressed("up") and !NO_STOCK:
			Global.play_sound(Global.ChestOpenSFX)
			Global.emit(global_position, 5)
			if Global.buy_item_perk(current_item.name.to_upper(), current_item.price * inflation, current_item.idx):
				$display/back/lbl_item.text = "== AGOTADO =="
				$display/back/sprite.animation = "no-stock"
				$display/back/arrows.animation = "empty"
				$display/back/lbl_price.text = ""
				$display/back/Coin.visible = false
				NO_STOCK = true
				Global.play_sound(Global.InteractSFX)
				active = true
				opened = false 
			else:
				$display/back/lbl_item.text = "== POBREZA ==" + "\nNo te quedan mas monedas =(" 
				$display/back/sprite.animation = "no-coin"
				$display/back/arrows.animation = "empty"
					
				active = true
				opened = true 
				ttl = 1.1

func _on_body_entered(body):
	if !opened and body.is_in_group("players") and !body.is_in_group("prisoners"):
		body.dont_camera = true
		$display.visible = true
		var center = Global.shaker_obj.camera.get_screen_center_position()
		$display.global_position = center
		active = true
		player = body
		if !NO_STOCK:
			$display/back/lbl_item.text = "== " + current_item.friendly_name.to_upper() + " ==" + "\n" + current_item.description
			$display/back/sprite.animation = current_item_name
		else:
			$display/back/lbl_item.text = "== AGOTADO =="
			$display/back/sprite.animation = "no-stock"
			$display/back/arrows.animation = "empty"
			$display/back/lbl_price.text = ""
			$display/back/Coin.visible = false

func _on_body_exited(body):
	if body.is_in_group("players") and !body.is_in_group("prisoners"):
		body.dont_camera = false
		$display.visible = false
		active = false
		opened = false
		body.dont_camera = false
