@tool
extends Node2D
class_name RouteVisualization

@export var line: Line2D
@export var speech_bubble: PackedScene
var speech_bubbles: Array[Sprite2D] = []

func display(person: Person):
	line.clear_points()
	line.add_point(person.position)
	for cur_bubble in speech_bubbles:
		cur_bubble.queue_free()
	speech_bubbles.clear()
	for keyframe_index in range(person.next_travel_node_index, person.route.size()):
		var cur_keyframe = person.route[keyframe_index]
		var travel_node = person.get_travel_node(cur_keyframe)
		var travel_node_pos = Vector2.ZERO
		if travel_node != null:
			travel_node_pos = travel_node.position
		line.add_point(travel_node_pos)
		if cur_keyframe.narration != "":
			var cur_bubble = speech_bubble.instantiate()
			add_child(cur_bubble)
			cur_bubble.owner = self
			cur_bubble.position = travel_node_pos
			(cur_bubble.get_child(0) as Label).text = cur_keyframe.narration.substr(0,15)
			(cur_bubble.get_child(1) as Label).text = str(keyframe_index)
			speech_bubbles.append(cur_bubble)
