@tool
extends Node2D
class_name Person

@export var route: Array[Keyframe] = []
var selected_from_person_editor: bool = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if selected_from_person_editor:
			display_route()
	else:
		travel()
	
	
func display_route():
	var route_vis = get_node("../../Route Visualization") #yeah ik this is bad practice but I couldnt find any other way to do it in-editor
	route_vis.clear_points()
	for keyframe in route:
		route_vis.add_point(get_travel_node(keyframe).position)

func travel():
	var keyframe_a
	var keyframe_b
	for keyframe_index in range(route.size()-1):
		keyframe_a = route[keyframe_index]
		keyframe_b = route[keyframe_index + 1]
		if GameManager.recording_time > keyframe_a.time and GameManager.recording_time < keyframe_b.time:
			var travel_max_time = keyframe_b.time - keyframe_a.time
			var travel_time = GameManager.recording_time - keyframe_a.time
			var travel_progress = travel_time / travel_max_time
			position = lerp(get_travel_node(keyframe_a).position,get_travel_node(keyframe_b).position,travel_progress)
			break

func get_travel_node(keyframe: Keyframe) -> TravelNode:
	return get_node(keyframe.travel_node_path) as TravelNode
