@tool
extends Node2D
class_name Person

@export var route: Array[Keyframe] = []
var selected_from_person_editor: bool = false
var next_travel_node_index: int

var map: Map

#currently only for editor view
func _process(_delta: float) -> void:
	map = get_node("../..") as Map #i know this is bad practice but it is for weird editor tool stuff
	map.route_vis.visible = Engine.is_editor_hint()
	if Engine.is_editor_hint():
		travel(PersonEditor.time)
		if selected_from_person_editor:
			map.route_vis.display(self)
			pass

func travel(cur_time: float):
	var keyframe_a
	var keyframe_b
	for keyframe_index in range(route.size()-1):
		keyframe_a = route[keyframe_index]
		keyframe_b = route[keyframe_index + 1]
		if cur_time > keyframe_a.time and cur_time < keyframe_b.time:
			var travel_max_time = keyframe_b.time - keyframe_a.time
			var travel_time = cur_time - keyframe_a.time
			var travel_progress = travel_time / travel_max_time
			next_travel_node_index = keyframe_index + 1
			position = lerp(get_travel_node(keyframe_a).position,get_travel_node(keyframe_b).position,travel_progress)
			break
	
func get_travel_node(keyframe: Keyframe) -> TravelNode:
	return get_node(keyframe.travel_node_path) as TravelNode
