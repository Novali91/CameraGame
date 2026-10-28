extends Control
class_name TaskbarIcon

@onready var nameBubble: Control = $NameBubble
var desktop: Desktop
var window: OSWindow

func set_title(new_name: String):
	nameBubble.get_node("Label").text = new_name

func _on_mouse_entered() -> void:
	nameBubble.visible = true

func _on_mouse_exited() -> void:
	nameBubble.visible = false

func _on_pressed() -> void:
	window.selected()
	if window.is_minimized:
		window.visible = true
		window.is_minimized = false
