extends Node2D
class_name Person

@export var route: Array[Keyframe] = []

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	self.position.x = GameManager.recording_time * 50

func _draw() -> void:
	draw_line(Vector2(0,0),Vector2(100,100),Color.RED)
