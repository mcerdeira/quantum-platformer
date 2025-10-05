extends Area2D
var ttl = 1
var tt_total = 7
var fires = preload("res://scenes/Fires.tscn")
var kill_me = null

func _ready():
	add_to_group("fires")
	if Global.BOSS_ROOM:
		$PointLight2D.visible = false

func _physics_process(delta):
	if ttl > 0:
		ttl -= 1 * delta
		if ttl <= 0:
			$collider.set_deferred("disabled", false)
			$collider2.set_deferred("disabled", false)
			$collider3.set_deferred("disabled", false)
			$collider4.set_deferred("disabled", false)
			$collider5.set_deferred("disabled", false)
			$collider6.set_deferred("disabled", false)
			$collider7.set_deferred("disabled", false)
			$collider8.set_deferred("disabled", false)
			$collider9.set_deferred("disabled", false)
			
			if visible:
				Global.emit(global_position, 5)
	
	var _sp = 1
	if Global.TerminalNumber == Global.TerminalsEnum.MERMAID:
		_sp = 2
	
	tt_total -= _sp * delta
	if tt_total <= 0:
		if visible:
			Global.emit(global_position, 5)
		if kill_me and is_instance_valid(kill_me):
			kill_me.dead_fire()
		queue_free() 
		
func extinguish_fire():
	Global.emit(global_position, 5)
	kill_me = null
	queue_free() 

func _on_body_shape_entered(body_rid, body, _body_shape_index, _local_shape_index):
	if body is TileMap:
		var coords = body.get_coords_for_body_rid(body_rid)
		if body.get_cell_source_id(0, coords) == Global.BurnableID:
			if !visible:
				tt_total = 5
			visible = true 
			var c = body.map_to_local(coords)
			var global_coords = c
			body.set_cell(0, coords, Global.BurnedID, Vector2(0, 0))
			
			var parent = get_parent()
			var p = fires.instantiate()
			p.position = global_coords
			#parent.add_child(p)
			parent.call_deferred("add_child", p)
			Global.emit(global_position, 5)
			
func _on_body_entered(body):
	if body and (body.is_in_group("players") or body.is_in_group("enemies")):
		if body.is_in_group("enemies"):
			if !Global.is_ok_FX(global_position):
				return
			
		if !visible:
			tt_total = 5
		visible = true
		body.kill_fire()
