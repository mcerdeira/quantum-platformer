extends TextEdit
@export var TerminalManager : Area2D

func _gui_input(event: InputEvent) -> void:
	if get_parent().get_parent().get_parent().is_writing:
		accept_event()
		return 
	if event is InputEventKey:
		var key_event := event as InputEventKey
		if key_event.keycode == Key.KEY_UP or key_event.keycode == Key.KEY_DOWN or key_event.keycode == Key.KEY_LEFT or key_event.keycode == Key.KEY_RIGHT:
			accept_event()
		elif key_event.keycode == Key.KEY_BACKSPACE:
			if !TerminalManager.command_ok:
				accept_event()
