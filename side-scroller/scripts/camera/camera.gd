class_name Camera
extends Camera2D

@export var target: Node2D

@export_group("Fixed X Position Options")
@export var use_fixed_x_position: bool = false
@export var fixed_x_position: float = 0.0

@export_group("Fixed Y Position Options")
@export var use_fixed_y_position: bool = false
@export var fixed_y_position: float = 0.0


func _ready() -> void:
	var viewport_size: Vector2 = get_viewport_rect().size

	if fixed_x_position == 0.0:
		fixed_x_position = viewport_size.x / 2.0

	if fixed_y_position == 0.0:
		fixed_y_position = viewport_size.y / 2.0


func _physics_process(_delta: float) -> void:
	if target == null:
		return

	var target_x_position: float = fixed_x_position if use_fixed_x_position else target.global_position.x
	var target_y_position: float = fixed_y_position if use_fixed_y_position else target.global_position.y

	global_position = Vector2(target_x_position, target_y_position)
