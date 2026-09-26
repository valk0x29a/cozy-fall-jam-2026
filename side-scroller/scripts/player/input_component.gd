class_name InputComponent
extends Node

var is_blowing: bool = false
var current_mouse_position: Vector2 = Vector2.ZERO


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_blowing = event.pressed
		current_mouse_position = event.position

func _process(_delta: float) -> void:
	if is_blowing:
		current_mouse_position = get_viewport().get_mouse_position()
