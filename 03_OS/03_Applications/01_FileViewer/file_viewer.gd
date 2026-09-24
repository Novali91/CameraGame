extends VBoxContainer

var filesystem: Folder = load("res://03_OS/04_Filesystem/01_HardcodedFiles/01_Folders/home.tres")

var _folder_scope: Array[Folder]

@onready var _file_container: FileContainer = $PanelContainer/MarginContainer/FileContainer
@onready var _bar: FileViewerBar = $FileViewerBar

var window: PackedScene = preload("res://03_OS/01_Windows/02_Window_Variants/file_reader_window.tscn")
var taskbar_icon: PackedScene = preload("res://03_OS/03_Taskbar_Icons/file_reader_icon.tscn")
@onready var desktop: Desktop = get_node("/root/Game/Desktop")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_bar.exit.connect(_exit_folder)
	_file_container.child_pressed.connect(_item_pressed)
	_enter_folder(filesystem)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _item_pressed(item: VisualFile) -> void:
	if item.is_folder:
		_enter_folder(item.attached_resource)
	else:
		var cur_window = desktop.add_window(window, taskbar_icon)
		var file = (item.attached_resource as File).attached_pdf.instantiate()
		var application = cur_window.get_node("Window/ResizeMargins/VBoxContainer/Control/FileReader")
		application.add_child(file)
		file.owner = application
		cur_window._os_bar.title = file.name
		cur_window._os_bar.update_title_and_icon()

func _enter_folder(folder: Folder) -> void:
	_folder_scope.append(folder)
	for file: VisualFile in _file_container.get_children():
		_file_container.delete_child(file)
	
	for item: Resource in folder.children:
		_file_container.create_child(item)
	
	_bar.enter_folder(folder.resource_name)
	pass

func _exit_folder() -> void:
	if _folder_scope.size() == 1:
		return
	_folder_scope.remove_at(_folder_scope.size()-1)
	
	for file: VisualFile in _file_container.get_children():
		_file_container.delete_child(file)
	
	for item: Resource in _folder_scope.get(_folder_scope.size()-1).children:
		_file_container.create_child(item)
	
	_bar.exit_folder()
	pass
