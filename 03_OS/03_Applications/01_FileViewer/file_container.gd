extends HFlowContainer

@onready var _visual_file: PackedScene = preload("res://03_OS/04_Filesystem/visual_file.tscn")

signal child_pressed(child: VisualFile)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_child(resource: Resource) -> void:
	var new_file: VisualFile = _visual_file.instantiate()
	new_file.attached_resource = resource
	new_file.is_folder = resource is Folder
	add_child(new_file)
	pass
