extends Control

@export var time_between_lines: float
var terminal_line: PackedScene = preload("res://03_OS/03_Applications/02_Terminal/terminal_line.tscn")
var line_time = 0.0
var line_count = 0
@export var login_screen: Control

var phrases: Array[String]

var boot_phrases: Array[String] = [
	"Interplanetary Corporate Workstation x128 v2.1",
	"Property of THE SOMA PROJECT",
	"Initializing SOMA/admin/home",
	"Initializing SOMA/admin/external drive",
	"Initializing SOMA/admin/performance logs",
	"Initializing SOMA/admin/recovery",
	"Compiling shaders",
	"Recognized \"Camera Footage\" from port A",
	"...",
	"Launching...",
	"...",
	"..."
]

var login_phrases: Array[String] = [
	"Attempting to access SOMA/admin",
	"User accessed successfully",
	"Checking for crash reports",
	"None found",
	"Loading user files",
	"Loading user preferences",
	"Loading desktop",
	"...",
	"..."
]

func _ready() -> void:
	phrases = boot_phrases

func login():
	visible = true
	line_count = 0
	line_time = 0
	phrases = login_phrases
	for child in $VBoxContainer.get_children():
		$VBoxContainer.remove_child(child)
		child.queue_free()

func _process(delta: float) -> void:
	if line_count < phrases.size():
		line_time += delta
		if line_time > time_between_lines:
			var new_line = terminal_line.instantiate()
			new_line.text = phrases[line_count]
			$VBoxContainer.add_child(new_line)
			line_time = 0.0
			line_count += 1
	elif phrases == boot_phrases:
		visible = false
	else:
		login_screen.visible = false
