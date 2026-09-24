extends OSWindow
class_name CameraWindow

@onready var map: Map = $Window/ResizeMargins/VBoxContainer/Control/AspectRatioContainer/SubViewportContainer/SubViewport/Map as Map
@onready var time_slider: HSlider = $Window/ResizeMargins/VBoxContainer/Control/HBoxContainer/TimeSlider as HSlider
@onready var camera_selector: OptionButton = $Window/ResizeMargins/VBoxContainer/Control/CameraSelector as OptionButton
@onready var play_pause: TextureButton = $Window/ResizeMargins/VBoxContainer/Control/HBoxContainer/PlayPause as TextureButton
var play_pause_icons: Array[Texture2D] = [
	preload("res://01_Assets/02_Icons/01_Recording_Buttons/play.png"),
	preload("res://01_Assets/02_Icons/01_Recording_Buttons/play2.png"),
	preload("res://01_Assets/02_Icons/01_Recording_Buttons/pause.png"),
	preload("res://01_Assets/02_Icons/01_Recording_Buttons/pause2.png")
]
var time: float = 0.0
var play_speed: float = 0.0

func _ready():
	super()
	update_camera_list()

func update_camera_list():
	camera_selector.clear()
	for camera_location in map.camera_locations:
		var camera_found = false
		for camera_details in GameManager.cameras:
			if camera_details.id == camera_location.name and camera_details.unlocked:
				camera_found = true
				break
		if camera_found:
			camera_selector.add_item(camera_location.name)

func _process(delta: float) -> void:
	time += play_speed * delta
	time = clamp(time,0,map.max_time)
	time_slider.value = time
	map.play(time,camera_selector.get_item_text(camera_selector.selected))

func _on_play_pause_pressed() -> void:
	if play_speed == 0.0:
		play_speed = 1.0
		play_pause.texture_normal = play_pause_icons[2]
		play_pause.texture_hover = play_pause_icons[3]
	else:
		play_speed = 0.0
		play_pause.texture_normal = play_pause_icons[0]
		play_pause.texture_hover = play_pause_icons[1]

func _on_time_slider_value_changed(value: float) -> void:
	time = time_slider.value

func _on_fast_back_pressed() -> void:
	if play_speed > 1:
		play_speed /= 2
	else:
		play_speed = -abs(play_speed * 2)

func _on_fast_forward_pressed() -> void:
	if play_speed > -1:
		play_speed *= 2
	else:
		play_speed /= 2
