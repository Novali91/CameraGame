extends VBoxContainer

var filesystem: Folder = load("res://03_OS/04_Filesystem/01_HardcodedFiles/01_Folders/home.tres")

var _folder_scope: Array[Folder]

@onready var _file_container: HFlowContainer = $PanelContainer/FileContainer
@onready var _bar: FileViewerBar = $FileViewerBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_bar.exit.connect(_exit_folder)
	_enter_folder(filesystem)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _item_pressed(item: VisualFile) -> void:
	if item.is_folder:
		_enter_folder(item.attached_resource)
	else:
		# How do we handle opening files? Need to open PDFReader; do we pass a signal up to desktop?
		pass

func _enter_folder(folder: Folder) -> void:
	_folder_scope.append(folder)
	for file: VisualFile in _file_container.get_children():
		file.queue_free()
	
	for item: Resource in folder.children:
		var new_file: VisualFile = _visual_file.instantiate()
		new_file.attached_resource = item
		new_file.is_folder = item is Folder
		_file_container.add_child(new_file)
	
	_bar.enter_folder(folder.resource_name)
	pass

func _exit_folder() -> void:
	_folder_scope.remove_at(_folder_scope.size()-1)
	
	for file: VisualFile in _file_container.get_children():
		file.queue_free()
	
	for item: Resource in _folder_scope.get(_folder_scope.size()-1).children:
		var new_file: VisualFile = _visual_file.instantiate()
		new_file.attached_resource = item
		new_file.is_folder = item is Folder
		_file_container.add_child(new_file)
	
	_bar.exit_folder()
	pass
