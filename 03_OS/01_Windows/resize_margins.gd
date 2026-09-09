extends MarginContainer

signal clicked(location: Vector2)
signal unclicked()

signal hovered(pos: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				print("Hi")
				clicked.emit(get_global_mouse_position())
			else:
				print("Bye")
				unclicked.emit()
	elif event is InputEventMouseMotion:
		print("Hi! Again")
		hovered.emit(get_global_mouse_position())
		
