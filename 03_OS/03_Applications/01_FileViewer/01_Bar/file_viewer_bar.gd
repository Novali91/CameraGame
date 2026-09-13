class_name FileViewerBar
extends HBoxContainer

var _filepath: PackedStringArray

@onready var _label: Label = $Label
@onready var _button: TextureButton = $TextureButton

signal exit

# Will display the filepath, so when we enter or exit a folder filepath will add or remove that folder's name, and then we will reconstruct the string (with /'s between them)

# Maybe will need to add functionality for making the filepath have some ...'s depending on min size of label and max size of the filepath

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_button.pressed.connect(exit.emit)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enter_folder(folder: String) -> void:
	_filepath.append(folder)
	_label.text = "/".join(_filepath)
	pass

func exit_folder() -> void:
	_filepath.remove_at(_filepath.size()-1)
	_label.text = "/".join(_filepath)
	pass
