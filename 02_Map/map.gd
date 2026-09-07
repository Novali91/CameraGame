extends Node
class_name Map
var recording_time: float = 0 #temporary, pass this value in later
@export var route_vis: RouteVisualization
var people: Array[Person] = []

func _ready() -> void:
	var people_nodes = get_node("People").get_children()
	for person_node in people_nodes:
		people.append(person_node as Person)

func _process(delta: float) -> void:
	recording_time += delta
	play(recording_time)

func play(time: float) -> void:
	for person in people:
		person.travel(time)
