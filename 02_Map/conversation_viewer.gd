extends Control
class_name ConversationViewer

@onready var list_node: VBoxContainer = $ScrollContainer/VBoxContainer
@export var conversation_line: PackedScene
var conversation: Conversation

func update_conversation(time: float):
	for child in list_node.get_children():
		child.queue_free()
		list_node.remove_child(child)
	if conversation == null or time < conversation.start_time or time > conversation.end_time:
		conversation = null
		return
	for line in conversation.lines:
		if line.time > time:
			break
		var temp = conversation_line.instantiate()
		temp.get_node("MarginContainer/MarginContainer/HBoxContainer/Portrait").texture = conversation.get_speaker(line.speaker).portrait
		temp.get_node("MarginContainer/MarginContainer/HBoxContainer/Text").text = line.content
		temp.get_node("MarginContainer/MarginContainer/HBoxContainer/Time").text = str(line.time) + "s"
		list_node.add_child(temp)
		temp.owner = list_node
