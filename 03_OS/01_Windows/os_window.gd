class_name OSWindow
extends Control

@onready var _os_bar: OSBar = $PanelContainer/MarginContainer/VBoxContainer/OSBar



func _ready() -> void:
	_os_bar.close_pressed.connect(_close)
	_os_bar.minimize_pressed.connect(_minimize)
	_os_bar.maximize_pressed.connect(_maximize)
	pass


func _process(delta: float) -> void:
	pass

func _minimize() -> void:
	print("min")
	pass

func _maximize(is_max: bool) -> void:
	print(is_max)
	pass

func _close() -> void:
	print("close")
	pass
