extends TextureButton

var is_max: bool = false

signal clicked(bool)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_is_pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _is_pressed() -> void:
	clicked.emit(is_max)
	is_max = not is_max
