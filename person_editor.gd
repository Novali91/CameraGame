@tool
extends EditorScript
class_name PersonEditor

var window: Window
var selected_person: Person
var root: Node = EditorInterface.get_edited_scene_root()
var people: Array[Person] = []
var route_vis: Line2D = root.get_node("Route Visualization")

func _run():
	window = Window.new()
	EditorInterface.popup_dialog(window, Rect2(Vector2(100,100),Vector2(1080,720)))
	window.close_requested.connect(func():
		window.queue_free()
	)
	
	var add_keyframe_button = Button.new()
	add_keyframe_button.text = "Add keyframe"
	add_keyframe_button.pressed.connect(func():
		add_keyframe()
	)
	window.add_child(add_keyframe_button)
	
	
	var people_nodes = root.get_node("People").get_children()
	for person_node in people_nodes:
		people.append(person_node as Person)
	var person_selector = OptionButton.new()
	for cur_person in people:
		person_selector.add_item(cur_person.name)
	selected_person = people[0]
	select_person(0)
	person_selector.item_selected.connect(select_person)
	person_selector.position.y = 50
	window.add_child(person_selector)
	
	selected_person.get_travel_node(selected_person.route[0])
	#for keyframe in selected_person.route:
	#	route_vis.add_point(Person.ge)
		
func add_keyframe():
	var temp = selected_person.route.duplicate()
	var kf: Keyframe = Keyframe.new()
	temp.append(kf)
	selected_person.route = temp

func select_person(index: int):
	selected_person.selected_from_person_editor = false
	selected_person = people[index]
	selected_person.selected_from_person_editor = true
