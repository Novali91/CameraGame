extends Node
var recording_time: float = 0
@export var route_vis: Line2D

func _process(delta: float) -> void:
	recording_time += delta
