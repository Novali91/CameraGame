extends OSWindow
class_name CameraWindow

@onready var map: Map = $Window/ResizeMargins/VBoxContainer/Control/AspectRatioContainer/SubViewportContainer/SubViewport/Map as Map
@onready var time_slider: HSlider = $Window/ResizeMargins/VBoxContainer/Control/TimeSlider as HSlider
@onready var camera_selector: OptionButton = $Window/ResizeMargins/VBoxContainer/Control/CameraSelector as OptionButton

func _ready():
	super()
	for camera_location in map.camera_locations:
		camera_selector.add_item(camera_location.name)

func _process(_delta: float) -> void:
	map.play(time_slider.value,camera_selector.get_item_text(camera_selector.selected))
