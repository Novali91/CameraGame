extends Node2D
class_name Person

@export var route: Array[Keyframe] = []

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	var keyframe_a
	var keyframe_b
	for keyframe_index in range(route.size()-1):
		keyframe_a = route[keyframe_index]
		keyframe_b = route[keyframe_index + 1]
		if GameManager.recording_time > keyframe_a.time and GameManager.recording_time < keyframe_b.time:
			var travel_max_time = keyframe_b.time - keyframe_a.time
			var travel_time = GameManager.recording_time - keyframe_a.time
			var travel_progress = travel_time / travel_max_time
			position = lerp((get_node(keyframe_a.travel_node_path) as TravelNode).position,(get_node(keyframe_b.travel_node_path) as TravelNode).position,travel_progress)
			break

func _draw() -> void:
	draw_line(Vector2(0,0),Vector2(100,100),Color.RED)
