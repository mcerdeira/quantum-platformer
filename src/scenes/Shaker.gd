extends Node2D

var camera_shake_intensity = 0.0
var camera_shake_duration = 0.0
var camera = null

enum Type {Random, Sine, Noise}
var camera_shake_type = Type.Random

func _ready():
	Global.shaker_obj = self
	
func shake(intensity, duration, type = Type.Random):
	if intensity > camera_shake_intensity and duration > camera_shake_duration:
		camera_shake_intensity = intensity
		camera_shake_duration = duration
		camera_shake_type = type

func _physics_process(delta):
	if camera == null:
		return
	
	if camera_shake_duration <= 0:
		# Reset the camera when the shaking is done
		camera.offset = Vector2(0, 0)
		camera_shake_intensity = 0.0
		camera_shake_duration = 0.0
		Global.CHROM_FX.resetdistor()
		return

	camera_shake_duration = camera_shake_duration - delta
	
	# Shake it
	var offset = Vector2.ZERO
		
	if camera_shake_type == Type.Random:
		offset = Vector2(randf(), randf()) * camera_shake_intensity

	Global.CHROM_FX.setdistort(randf())
	
	offset = offset
	
	camera.offset = offset
