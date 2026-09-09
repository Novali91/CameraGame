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

@onready var _hori_cursor = preload("res://01_Assets/02_Icons/side_cursor.png")
@onready var _vert_cursor = preload("res://01_Assets/02_Icons/vertical_cursor.png")
@onready var _bl_cursor = preload("res://01_Assets/02_Icons/bottom_left_cursor.png")
@onready var _br_cursor = preload("res://01_Assets/02_Icons/bottom_right_cursor.png")
@onready var _default_cursor = preload("res://01_Assets/02_Icons/default_cursor.png")

var _reset_cursor: bool = false
var desktop: Desktop
var taskbar_icon: TaskbarIcon

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
var _cur_loc: ResizeLocation = ResizeLocation.NONE

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
	_os_bar.clicked.connect(_bar_pressed)
	_os_bar.unclicked.connect(_bar_unpressed)
	_resize_margins.hovered.connect(_hover_resize_handles)
	_resize_margins.mouse_exited.connect(_unhover_resize_handles)
	pass


func _physics_process(delta: float) -> void:
	var delta_mouse_pos = get_global_mouse_position() - _last_mouse_pos
	if _resizing:
		_resize(delta_mouse_pos)
	elif _dragging:
		_drag(delta_mouse_pos)
		
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
	desktop.window_closed(self)
	queue_free()
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
	
	if _reset_cursor:
		_unhover_resize_handles()
		_reset_cursor = false
	
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
		print("Pos: %d, Bounds: %d, %d", [pos_x, glob_x, glob_x+MARGIN_SIZE])
		total = LEFT
	elif pos_x <= glob_x + size.x and pos_x >= glob_x + size.x - MARGIN_SIZE:
		print("Pos: %d, Bounds: %d, %d", [pos_x, glob_x+size.x, glob_x+size.x-MARGIN_SIZE])
		total = RIGHT
	
	if pos_y >= glob_y and pos_y <= (glob_y+MARGIN_SIZE):
		print("Pos: %d, Bounds: %d, %d", [pos_y, glob_y, glob_y+MARGIN_SIZE])
		total += TOP
	elif pos_y <= glob_y+size.y and pos_y >= glob_y + size.y - MARGIN_SIZE:
		print("Pos: %d, Bounds: %d, %d", [pos_y, glob_y+size.y, glob_y+size.y-MARGIN_SIZE])
		total += BOTTOM
	
	return _determine_location(total)

func _determine_location(loc: int) -> ResizeLocation:
	match loc:
		0: 
			return ResizeLocation.NONE
		LEFT:
			print("Left")
			return ResizeLocation.LEFT
		RIGHT:
			print("R")
			return ResizeLocation.RIGHT
		BOTTOM:
			print("B")
			return ResizeLocation.BOTTOM
		TOP:
			print("T")
			return ResizeLocation.TOP
		LEFT+BOTTOM:
			print("LB")
			return ResizeLocation.BOTTOM_LEFT
		LEFT+TOP:
			print("LT")
			return ResizeLocation.TOP_LEFT
		RIGHT+BOTTOM:
			print("RB")
			return ResizeLocation.BOTTOM_RIGHT
		RIGHT+TOP:
			print("RT")
			return ResizeLocation.TOP_RIGHT
		_:
			return ResizeLocation.NONE

func _resize(delta_mouse: Vector2) -> void:
	
	var min_size: Vector2 = get_custom_minimum_size()
	match _cur_loc:
		ResizeLocation.LEFT:
			var old_width: float = size.x
			size.x = max(size.x - delta_mouse.x, min_size.x)
			global_position.x += old_width - size.x
			
		ResizeLocation.RIGHT:
			size.x += delta_mouse.x
			
		ResizeLocation.BOTTOM:
			size.y += delta_mouse.y
			
		ResizeLocation.TOP:
			var old_height: float = size.y
			size.y = max(size.y - delta_mouse.y, min_size.y)
			global_position.y += old_height - size.y

		ResizeLocation.TOP_LEFT:
			var old_size: Vector2 = size
			
			size.x = max(size.x - delta_mouse.x, min_size.x)
			size.y = max(size.y - delta_mouse.y, min_size.y)

			global_position.x += old_size.x - size.x
			global_position.y += old_size.y - size.y
			
		ResizeLocation.TOP_RIGHT:
			var old_height: float = size.y

			size.x = max(size.x + delta_mouse.x, min_size.x)
			size.y = max(size.y - delta_mouse.y, min_size.y)

			global_position.y += old_height - size.y
			
		ResizeLocation.BOTTOM_LEFT:
			var old_width: float = size.x

			size.x = max(size.x - delta_mouse.x, min_size.x)
			size.y = max(size.y + delta_mouse.y, min_size.y)

			global_position.x += old_width - size.x
			
		ResizeLocation.BOTTOM_RIGHT:
			size.x += delta_mouse.x
			size.y += delta_mouse.y
	pass

func _hover_resize_handles(pos: Vector2) -> void:
	## If we add custom cursors, we should add that functionality here
	
	#print(_calculate_resize(pos))
	
	if _resizing:
		return
	
	var cur_pos: ResizeLocation = _determine_location(_calculate_resize(pos))
	
	match cur_pos:
		ResizeLocation.LEFT:
			DisplayServer.cursor_set_custom_image(_hori_cursor)
		ResizeLocation.RIGHT:
			DisplayServer.cursor_set_custom_image(_hori_cursor)
		ResizeLocation.TOP:
			DisplayServer.cursor_set_custom_image(_vert_cursor)
		ResizeLocation.BOTTOM:
			DisplayServer.cursor_set_custom_image(_vert_cursor)
		ResizeLocation.BOTTOM_LEFT:
			DisplayServer.cursor_set_custom_image(_bl_cursor)
		ResizeLocation.TOP_RIGHT:
			DisplayServer.cursor_set_custom_image(_bl_cursor)
		ResizeLocation.BOTTOM_RIGHT:
			DisplayServer.cursor_set_custom_image(_br_cursor)
		ResizeLocation.TOP_LEFT:
			DisplayServer.cursor_set_custom_image(_br_cursor)
	
	pass

func _unhover_resize_handles() -> void:
	## Set cursor back to whatever we make default cursor
	if _resizing:
		_reset_cursor = true
		return
	
	DisplayServer.cursor_set_custom_image(_default_cursor)
	
	pass

## For the bar movement

func _bar_pressed(pos: Vector2) -> void:
	_dragging = true
	
	pass

func _bar_unpressed() -> void:
	
	_dragging = false
	
	pass

func _drag(delta_mouse: Vector2) -> void:
	global_position += delta_mouse

func selected() -> void:
	move_to_front()
