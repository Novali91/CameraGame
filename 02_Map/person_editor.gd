@tool
extends EditorScript
class_name PersonEditor

var window: Window
var selected_person: Person
var root: Node = EditorInterface.get_edited_scene_root()
var people: Array[Person] = []
static var time: float = 0

var start_keyframe_box: SpinBox
var end_keyframe_box: SpinBox

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
	
	var time_slider = HSlider.new()
	time_slider.value_changed.connect(set_time)
	time_slider.position.y = 100
	time_slider.size.x = 100
	time_slider.min_value = 0
	time_slider.max_value = 10 #kind random enpoint idk, change later
	time_slider.step = 0.01
	window.add_child(time_slider)
	
	start_keyframe_box = SpinBox.new()
	end_keyframe_box = SpinBox.new()
	var fill_speed_button = Button.new()
	window.add_child(start_keyframe_box)
	window.add_child(end_keyframe_box)
	window.add_child(fill_speed_button)
	start_keyframe_box.position.y = 150
	end_keyframe_box.position.y = 150
	end_keyframe_box.position.x = 200
	fill_speed_button.position.y = 150
	fill_speed_button.position.x = 400
	fill_speed_button.text = "Fill speed"
	fill_speed_button.pressed.connect(fill_speed)
	
func add_keyframe():
	var temp = selected_person.route.duplicate()
	var kf: Keyframe = Keyframe.new()
	temp.append(kf)
	selected_person.route = temp

func select_person(index: int):
	selected_person.selected_from_person_editor = false
	selected_person = people[index]
	selected_person.selected_from_person_editor = true

func set_time(time: float):
	self.time = time

func fill_speed():
	for keyframe_index in range(start_keyframe_box.value + 1, end_keyframe_box.value):
		var cur_kf = selected_person.route[keyframe_index]
		var prev_kf = selected_person.route[keyframe_index-1]
		var dist = (selected_person.get_travel_node(cur_kf).position - selected_person.get_travel_node(prev_kf).position).length()
		cur_kf.time = prev_kf.time + dist / selected_person.speed
