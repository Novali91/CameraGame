extends VBoxContainer

var filesystem: Folder = load("res://03_OS/04_Filesystem/01_HardcodedFiles/01_Folders/home.tres")

var _folder_scope: Array[Folder]

@onready var _file_container: FileContainer = $PanelContainer/MarginContainer/FileContainer
@onready var _bar: FileViewerBar = $FileViewerBar
@onready var _search_bar: LineEdit = $FileViewerBar/SearchBar

var window: PackedScene = preload("res://03_OS/01_Windows/02_Window_Variants/file_reader_window.tscn")
var taskbar_icon: PackedScene = preload("res://03_OS/03_Taskbar_Icons/file_reader_icon.tscn")
@onready var desktop: Desktop = get_node("/root/Game/Desktop")

var all_files_and_folders = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_bar.exit.connect(_exit_folder)
	_file_container.child_pressed.connect(_item_pressed)
	_read_all_files_and_folders()
	_enter_folder(filesystem)
	pass # Replace with function body.

func _read_all_files_and_folders():
	var parents = [filesystem]
	while parents != []:
		var cur = parents.pop_back()
		all_files_and_folders.append(cur)
		if cur is Folder:
			for child in (cur as Folder).children:
				parents.append(child)

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
	clear()
	
	for item: Resource in folder.children:
		_file_container.create_child(item)
	
	_bar.enter_folder(folder.resource_name)
	pass

func _exit_folder() -> void:
	if _folder_scope.size() == 1:
		return
	_folder_scope.remove_at(_folder_scope.size()-1)
	
	clear()
	
	for item: Resource in _folder_scope.get(_folder_scope.size()-1).children:
		_file_container.create_child(item)
	
	_bar.exit_folder()
	pass

func get_children_recursive(parent: Node) -> Array[Node]:
	var children: Array[Node] = [parent]
	for child in parent.get_children():
		children.append_array(get_children_recursive(child))
	return children

func _search(keyword: String) -> void:
	if keyword == "":
		_enter_folder(filesystem)
		return
	clear()
	
	for file_folder in all_files_and_folders:
		var matching_string_found = false
		if file_folder is Folder and (file_folder as Folder).resource_name.containsn(keyword):
			matching_string_found = true
		if file_folder is File:
			if (file_folder as File).resource_name.containsn(keyword):
				matching_string_found = true
			var temp_file:Node = file_folder.attached_pdf.instantiate()
			
			var i = 0
			var children = get_children_recursive(temp_file)
			while i < children.size() and not matching_string_found:
				var child = children[i]
				if child is Label and (child as Label).text.containsn(keyword):
					matching_string_found = true
					break
				i += 1
		if matching_string_found:
			_file_container.create_child(file_folder)

func clear() -> void:
	for file: VisualFile in _file_container.get_children():
		_file_container.delete_child(file)

func _on_search_bar_text_submitted(new_text: String) -> void:
	_search(new_text)

func _on_search_button_pressed() -> void:
	_search(_search_bar.text)
