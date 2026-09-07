@tool
extends Node2D
class_name Person

@export var route: Array[Keyframe] = []
var selected_from_person_editor: bool = false
var next_travel_node_index: int

#currently only for editor view
func _process(_delta: float) -> void:
	var map = get_node("../..") as Map
	map.route_vis.visible = Engine.is_editor_hint()
	if Engine.is_editor_hint():
		travel(PersonEditor.time)
		if selected_from_person_editor:
			display_route(map)
	
#currently only for editor view
func display_route(map: Map):
	map.route_vis.clear_points()
	map.route_vis.add_point(position)
	for keyframe_index in range(next_travel_node_index, route.size()):
		map.route_vis.add_point(get_travel_node(route[keyframe_index]).position)

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
