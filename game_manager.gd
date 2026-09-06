extends Node
var recording_time: float = 0

func _process(delta: float) -> void:
	recording_time += delta
