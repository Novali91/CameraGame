@tool
extends Node
class_name Conversation

@export var lines: Array[DialogueLine] = []
var participants: Array[Person] = []
@export var start_time: float
@export var end_time: float

func update():
	var new_participants: Array[Person] = []
	start_time = -1
	end_time = -1
	for line in lines:
		var speaker = get_speaker(line.speaker)
		if not new_participants.has(speaker):
			new_participants.append(speaker)
		if line.time < start_time or start_time == -1:
			start_time = line.time
		if line.time > end_time or end_time == -1:
			end_time = line.time
	participants = new_participants

func get_speaker(person_path: NodePath) -> Person:
	return get_node(person_path) as Person
