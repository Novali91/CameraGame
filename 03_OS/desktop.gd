extends Control
class_name Desktop

@onready var taskbar = $Taskbar
var windows: Array[OSWindow] = []
var windows3: Array[OSWindow] = []
var taskbar_icons: Array[TaskbarIcon] = []

@export var taskbar_icon_spacing: float

func add_window(window_scene: PackedScene, taskbar_icon_scene: PackedScene):
	var window = window_scene.instantiate() as OSWindow
	add_child(window)
	window.owner = self
	windows.append(window)
	windows3.append(window)
	window.desktop = self
	
	var taskbar_icon = taskbar_icon_scene.instantiate() as TaskbarIcon
	taskbar.add_child(taskbar_icon)
	taskbar_icon.owner = taskbar
	taskbar_icons.append(taskbar_icon)
	taskbar_icon.window = window
	taskbar_icon.desktop = self
	window.taskbar_icon = taskbar_icon
	order_taskbar()

func order_taskbar():
	for icon_index in range(taskbar_icons.size()):
		var taskbar_icon = taskbar_icons[icon_index]
		taskbar_icon.position.y = 25 #magic number idc man
		taskbar_icon.position.x = icon_index * taskbar_icon_spacing + 25 #another magic number idgaf

func window_closed(window: OSWindow):
	####something here
	taskbar_icons.erase(window.taskbar_icon)
	windows.erase(window)
	window.taskbar_icon.queue_free()
	order_taskbar()

func update_cams_in_cam_windows():
	for window in windows:
		if window is CameraWindow:
			(window as CameraWindow).update_camera_list()
