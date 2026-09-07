extends Node
class_name Map
var recording_time: float = 0 #temporary, pass this value in later
@export var route_vis: RouteVisualization
@export var cam: Camera2D
@export var people_node: Node
@export var camera_locations_node: Node
var people: Array[Person] = []
var camera_locations: Array[Marker2D] = []

func _ready() -> void:
	var people_nodes = people_node.get_children()
	for person_node in people_nodes:
		people.append(person_node as Person)
	var camera_locations_nodes = camera_locations_node.get_children()
	for camera_location_node in camera_locations_nodes:
		camera_locations.append(camera_location_node as Marker2D)

#temporary. Should be passed in by OS instead
func _process(delta: float) -> void:
	recording_time += delta
	play(recording_time, 0)

func play(time: float, cam_id: int) -> void:
	cam.position = camera_locations[cam_id].position
	for person in people:
		person.travel(time)
