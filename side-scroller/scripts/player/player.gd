class_name Player
extends CharacterBody2D

@export var camera: Camera2D
@export var tile_map_layer: TileMapLayer
@export var player_size := Vector2(16, 16)

@onready var input_component: InputComponent = $InputComponent
@onready var physics_component: PhysicsComponent = $PhysicsComponent
@onready var collision_component: CollisionComponent = $CollisionComponent


func _physics_process(delta: float) -> void:
	var screen_position: Vector2 = get_viewport_transform() * global_position
	
	var physical_collision_data: PhysicalCollisionData = collision_component.get_physical_collision_data(self, tile_map_layer)
	var logical_collision_data: LogicalCollisionData = collision_component.get_logical_collision_data(self, tile_map_layer)
	
	var on_floor: bool = is_on_floor()
	var in_water: bool = logical_collision_data.is_water
	
	var blow_direction: Vector2 = Vector2.ZERO

	if input_component.is_blowing:
		blow_direction = (screen_position - input_component.current_mouse_position).normalized()
		
	var gust_direction: Vector2 = logical_collision_data.gust_direction
	var waterfall_direction: Vector2 = logical_collision_data.waterfall_direction
		
	velocity = physics_component.calculate_velocity(velocity, on_floor, in_water, blow_direction, gust_direction, waterfall_direction, delta)

	move_and_slide()
	
	if camera:
		var half_width: float = player_size.x * 0.5
		var half_height: float = player_size.y * 0.5

		global_position.x = clamp(global_position.x, camera.limit_left + half_width, camera.limit_right - half_width)
		global_position.y = clamp(global_position.y, camera.limit_top + half_height, camera.limit_bottom - half_height)

	if physical_collision_data.is_hazard:
		print("Hazard!")

	if physical_collision_data.is_win:
		print("Win!")
