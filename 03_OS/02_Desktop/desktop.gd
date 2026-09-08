extends Node2D
class_name Desktop

@onready var taskbar = $Taskbar
var windows: Array[OSWindow] = []
var taskbar_icons: Array[Button] = []

@export var taskbar_icon_spacing: float

func add_window(window_scene: PackedScene, taskbar_icon_scene: PackedScene):
	var window = window_scene.instantiate() as OSWindow
	add_child(window)
	window.owner = self
	windows.append(window)
	
	var taskbar_icon = taskbar_icon_scene.instantiate() as TaskbarIcon
	taskbar.add_child(taskbar_icon)
	taskbar_icon.owner = taskbar
	taskbar_icons.append(taskbar_icon)
	taskbar_icon.window = window
	order_taskbar()

func order_taskbar():
	for icon_index in range(taskbar_icons.size()):
		var taskbar_icon = taskbar_icons[icon_index]
		taskbar_icon.position.y = 15 #magic number idc man
		taskbar_icon.position.x = icon_index * taskbar_icon_spacing
