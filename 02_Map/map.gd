extends Node
class_name Map
@export var route_vis: RouteVisualization
@export var cam: Camera2D
@export var people_node: Node
@export var camera_locations_node: Node
@export var conversations_node: Node
@export var conversation_viewer: ConversationViewer
var people: Array[Person] = []
var camera_locations: Array[Marker2D] = []
var conversations: Array[Conversation] = []

func _ready() -> void:
	var people_nodes = people_node.get_children()
	for person_node in people_nodes:
		people.append(person_node as Person)
	var camera_locations_nodes = camera_locations_node.get_children()
	for camera_location_node in camera_locations_nodes:
		camera_locations.append(camera_location_node as Marker2D)
	for conversation_node in conversations_node.get_children():
		conversations.append(conversation_node as Conversation)
	for person in people:
		for conversation in person.conversations:
			conversation.update()

func play(time: float, cam_name: String) -> void:
	cam.position = get_camera_location(cam_name).position
	for person in people:
		person.travel(time)
	conversation_viewer.update_conversation(time)

func get_camera_location(cam_name: String) -> Marker2D:
	for camera_location in camera_locations:
		if camera_location.name == cam_name:
			return camera_location
	return null
