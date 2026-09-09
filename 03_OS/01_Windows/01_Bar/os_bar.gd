class_name OSBar
extends PanelContainer

## Height: 44 pixels
## Button size: 32x32, icon is 32x32

signal close_pressed
signal minimize_pressed
signal maximize_pressed

signal clicked(pos: Vector2)
signal unclicked

@onready var _maximize: TextureButton = $HBoxContainer/HBoxContainer/Maximize
@onready var _minimize: TextureButton = $HBoxContainer/HBoxContainer/Minimize
@onready var _close: TextureButton = $HBoxContainer/HBoxContainer/Close
@onready var _blank: Control = $HBoxContainer/Blank


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	_maximize.clicked.connect(_maximize_pressed_emit)
	_minimize.pressed.connect(_minimize_pressed_emit)
	_close.pressed.connect(_close_pressed_emit)
	_blank.clicked.connect(_bar_pressed)
	_blank.unclicked.connect(_bar_unpressed)
	
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

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				
				clicked.emit(get_global_mouse_position())
			else:
				unclicked.emit()

func _bar_pressed(pos: Vector2) -> void:
	clicked.emit(pos)

func _bar_unpressed() -> void:
	unclicked.emit()
