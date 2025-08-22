extends Label

func _ready() -> void:
	text = "build v" + ProjectSettings.get_setting("application/config/version")
