extends Button
class_name TaskbarIcon

@onready var label: Label = $Label
var desktop: Desktop
var window: OSWindow

func _on_mouse_entered() -> void:
	label.visible = true

func _on_mouse_exited() -> void:
	label.visible = false

func _on_pressed() -> void:
	window.selected()
