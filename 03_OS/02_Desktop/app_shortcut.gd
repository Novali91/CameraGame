extends Node2D
class_name App_Shortcut

@onready var desktop = get_node("..") as Desktop
@export var window_scene: PackedScene
@export var taskbar_icon_scene: PackedScene

func _on_button_pressed() -> void:
	desktop.add_window(window_scene, taskbar_icon_scene)
