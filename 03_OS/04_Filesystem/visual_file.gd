class_name VisualFile
extends VBoxContainer

var is_folder: bool
var attached_resource: Resource

@onready var _image: TextureRect = $TextureRect
@onready var _name: Label = $Label

signal pressed(file: VisualFile)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_folder:
		_image.texture = load("res://01_Assets/02_Icons/folder.png")
	else:
		_image.texture = load("res://01_Assets/02_Icons/file.png")
	
	_name.text = attached_resource.resource_name
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				pressed.emit(self)
