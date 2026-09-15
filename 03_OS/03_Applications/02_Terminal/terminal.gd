extends Control
class_name Terminal

@onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var cur_line: HBoxContainer = $ScrollContainer/VBoxContainer/CurLine
@onready var cur_line_text: LineEdit = $ScrollContainer/VBoxContainer/CurLine/LineEdit
@onready var cur_line_prefix: Label = $ScrollContainer/VBoxContainer/CurLine/Prefix
@onready var lines_node: VBoxContainer = $ScrollContainer/VBoxContainer
@onready var terminal_line_scene: PackedScene = preload("res://03_OS/03_Applications/02_Terminal/terminal_line.tscn")
var terminal_lines: Array[Label] = []

var help_text: String = "COMMAND LIST:
	
	\"help\" - prints list of commands
	\"unlock <id> <password>\" - unlocks an object where <id> is the id of the object and <password> is the password of the object. Objects can be cameras, doors, etc
	\"clear\" - removes previous commands from terminal
	"

func _ready():
	cur_line_text.grab_focus()

func _on_line_edit_text_submitted(command: String) -> void:
	add_line(command, true)
	execute_command(command)

func add_line(text: String, is_command: bool):
	var terminal_line: Label = terminal_line_scene.instantiate()
	if is_command:
		terminal_line.text = cur_line_prefix.text + text
	else:
		terminal_line.text = text
	cur_line_text.text = ""
	terminal_lines.append(terminal_line)
	lines_node.add_child(terminal_line)
	terminal_line.owner = lines_node
	lines_node.move_child(cur_line,lines_node.get_child_count())
	cur_line_text.grab_focus()
	await get_tree().process_frame
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value

func check_argument_count(tokens: Array[String], expected_tokens: int) -> bool:
	if tokens.size() == expected_tokens:
		return true
	else:
		add_line("Expected " + str(expected_tokens - 1) + " arguments",false)
		return false

func execute_command(command: String):
	var tokens = command.strip_edges().split(" ")
	match tokens[0]:
		"help":
			if check_argument_count(tokens,1):
				add_line(help_text,false)
		"unlock":
			#gotta wait for cameras to have ids and paasswords
			pass
		"clear":
			if check_argument_count(tokens, 1):
				for terminal_line in terminal_lines:
					lines_node.remove_child(terminal_line)
					terminal_line.queue_free()
				terminal_lines.clear()
		_:
			add_line("Unknown command. Try \"help\" for list of commands.",false)
