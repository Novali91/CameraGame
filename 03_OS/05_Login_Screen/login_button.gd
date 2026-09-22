extends Button

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.play("default")

func _on_mouse_entered() -> void:
	sprite.pause()
	sprite.frame = 1

func _on_mouse_exited() -> void:
	sprite.play("default")
	sprite.frame = 0
