extends TileMapLayer

@export var camera: Camera2D


func _ready() -> void:
	var used_rectangle: Rect2 = get_used_rect()
	var tile_size: Vector2i = tile_set.tile_size
	
	var left_pixels: float = used_rectangle.position.x * tile_size.x
	var right_pixels: float = used_rectangle.end.x * tile_size.x
	
	var global_left_limit: float = global_position.x + (left_pixels * global_scale.x)
	var global_right_limit: float = global_position.x + (right_pixels * global_scale.x)
	
	camera.limit_left = int(global_left_limit)
	camera.limit_right = int(global_right_limit)
