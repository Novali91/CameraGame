class_name OSBar
extends PanelContainer

## Height: 44 pixels
## Button size: 32x32, icon is 32x32

signal close_pressed
signal minimize_pressed
signal maximize_pressed

@onready var _maximize: TextureButton = $HBoxContainer/HBoxContainer/Maximize
@onready var _minimize: TextureButton = $HBoxContainer/HBoxContainer/Minimize
@onready var _close: TextureButton = $HBoxContainer/HBoxContainer/Close


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	_maximize.clicked.connect(_maximize_pressed_emit)
	_minimize.pressed.connect(_minimize_pressed_emit)
	_close.pressed.connect(_close_pressed_emit)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _close_pressed_emit() -> void:
	close_pressed.emit()

func _maximize_pressed_emit(is_max: bool) -> void:
	maximize_pressed.emit(is_max)

func _minimize_pressed_emit() -> void:
	minimize_pressed.emit()
