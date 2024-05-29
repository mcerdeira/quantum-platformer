extends ColorRect
var default = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.CHROM_FX = self
	
func resetdistor():
	material.set_shader_parameter("amount", default)

func setdistort(val):
	material.set_shader_parameter("amount", val)
