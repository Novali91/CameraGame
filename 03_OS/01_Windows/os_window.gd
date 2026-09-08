class_name OSWindow
extends Control

# Change if margins change
const MARGIN_SIZE: int = 10

const LEFT: int = 1
const RIGHT: int = 2
const BOTTOM: int = 8
const TOP: int = 4

@onready var _os_bar: OSBar = $Window/ResizeMargins/VBoxContainer/OSBar
@onready var _window = $Window
@onready var _resize_margins: MarginContainer = $Window/ResizeMargins

enum ResizeLocation {
	TOP,
	LEFT,
	RIGHT,
	BOTTOM,
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
	NONE
}

# If holding down on a side of the window to resize:
var _resizing: bool = false
var _cur_loc: ResizeLocation

var _last_mouse_pos: Vector2

# To resize:
# _check_resize: See if mouse is in any of the areas to start resizing

# If holding down on the top bar of window to drag:
var _dragging: bool = false

func _ready() -> void:
	_os_bar.close_pressed.connect(_close)
	_os_bar.minimize_pressed.connect(_minimize)
	_os_bar.maximize_pressed.connect(_maximize)
	_resize_margins.clicked.connect(_check_resize)
	_resize_margins.unclicked.connect(_unresize)
	pass


func _physics_process(delta: float) -> void:
	if _resizing:
		var delta_mouse_pos = get_global_mouse_position() - _last_mouse_pos
		_resize(delta_mouse_pos)
	
	_last_mouse_pos = get_global_mouse_position()
	pass

## For buttons in the top bar:
func _minimize() -> void:
	print("min")
	pass

func _maximize(is_max: bool) -> void:
	print(is_max)
	pass

func _close() -> void:
	print("close")
	pass

func _check_resize(pos: Vector2) -> void:
	var loc: ResizeLocation = _calculate_resize(pos)
	
	if loc == ResizeLocation.NONE:
		return
	
	_cur_loc = loc
	_resizing = true
	
	## Change cursor?
	
	pass

func _unresize() -> void:
	
	_resizing = false
	_cur_loc = ResizeLocation.NONE
	
	## Change cursor?
	
	pass
## For resizing:
func _calculate_resize(pos: Vector2) -> ResizeLocation:
	## Left is 1, right is 2, top is 4, bottom is 8, switch statement to figure out what the number represents (eg, top-left is 5)
	var total: int = 0
	
	var pos_x: float = pos.x
	var pos_y: float = pos.y
	var glob_x: float = global_position.x
	var glob_y: float = global_position.y
	## Check left/right:
	
	if pos_x >= glob_x and pos_x <= (glob_x+MARGIN_SIZE):
		total = LEFT
	elif pos_x <= glob_x + size.x and pos_x >= glob_x + size.x - MARGIN_SIZE:
		total = RIGHT
	
	if pos_y >= glob_y and pos_y <= (glob_y+MARGIN_SIZE):
		total += TOP
	elif pos_y <= glob_y+size.y and pos_y >= glob_y + size.y - MARGIN_SIZE:
		total += BOTTOM
	
	return _determine_location(total)

func _determine_location(loc: int) -> ResizeLocation:
	match loc:
		LEFT:
			return ResizeLocation.LEFT
		RIGHT:
			return ResizeLocation.RIGHT
		BOTTOM:
			return ResizeLocation.BOTTOM
		TOP:
			return ResizeLocation.TOP
		LEFT+BOTTOM:
			return ResizeLocation.BOTTOM_LEFT
		LEFT+TOP:
			return ResizeLocation.TOP_LEFT
		RIGHT+BOTTOM:
			return ResizeLocation.BOTTOM_RIGHT
		RIGHT+TOP:
			return ResizeLocation.TOP_RIGHT
		_:
			return ResizeLocation.NONE

func _resize(delta_mouse: Vector2) -> void:
	
	match _cur_loc:
		ResizeLocation.LEFT:
			delta_mouse.x = min(delta_mouse.x, size.x-get_custom_minimum_size().x)
			size.x -= delta_mouse.x
			if (size.x > get_custom_minimum_size().x):
				print(size.x)
				print(get_custom_minimum_size().x)
				global_position.x += delta_mouse.x
		ResizeLocation.RIGHT:
			size.x += delta_mouse.x
		ResizeLocation.BOTTOM:
			size.y += delta_mouse.y
		ResizeLocation.TOP:
			size.y -= delta_mouse.y
			global_position.y += delta_mouse.y
		ResizeLocation.TOP_LEFT:
			size.x -= delta_mouse.x
			if (size.x > get_minimum_size().x):
				global_position.x += delta_mouse.x
			size.y -= delta_mouse.y
			global_position.y += delta_mouse.y
		ResizeLocation.TOP_RIGHT:
			size.x += delta_mouse.x
			size.y -= delta_mouse.y
			global_position.y += delta_mouse.y
		ResizeLocation.BOTTOM_LEFT:
			size.x -= delta_mouse.x
			if (size.x > get_minimum_size().x):
				global_position.x += delta_mouse.x
			size.y += delta_mouse.y
		ResizeLocation.BOTTOM_RIGHT:
			size.x += delta_mouse.x
			size.y += delta_mouse.y
	pass
