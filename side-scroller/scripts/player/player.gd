class_name Player
extends CharacterBody2D

@export var camera: Camera2D
@export var midground_layer: TileMapLayer
@export var foreground_layer: TileMapLayer
@export var player_size := Vector2(16, 16)

@export_group("Health & Invincibility")
@export var max_lives: int = 3
@export var invincibility_duration: float = 1.5
@export var flash_interval: float = 0.1

var current_lives: int
var is_invincible: bool = false
var _invincibility_timer: float = 0.0
var _flash_timer: float = 0.0

@onready var input_component: InputComponent = $InputComponent
@onready var physics_component: PhysicsComponent = $PhysicsComponent
@onready var collision_component: CollisionComponent = $CollisionComponent


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	current_lives = max_lives

func _physics_process(delta: float) -> void:
	_handle_invincibility(delta)

	var screen_position: Vector2 = get_viewport_transform() * global_position
	
	var physical_collision_data: PhysicalCollisionData = collision_component.get_physical_collision_data(self, midground_layer)
	var logical_collision_data: LogicalCollisionData = collision_component.get_logical_collision_data(self, foreground_layer)
	
	var on_floor: bool = is_on_floor()
	var in_water: bool = logical_collision_data.is_water
	
	var blow_direction: Vector2 = Vector2.ZERO

	if input_component.is_blowing:
		blow_direction = (screen_position - input_component.current_mouse_position).normalized()
		
	var gust_direction: Vector2 = logical_collision_data.gust_direction
	var waterfall_direction: Vector2 = logical_collision_data.waterfall_direction
		
	velocity = physics_component.calculate_velocity(velocity, on_floor, in_water, blow_direction, gust_direction, waterfall_direction, delta)

	move_and_slide()

	if camera and _is_out_of_bounds():
		die()

	if physical_collision_data.is_hazard and not is_invincible:
		take_damage(1)

	if physical_collision_data.is_win:
		win()

func take_damage(amount: int = 1) -> void:
	if is_invincible:
		return

	current_lives -= amount

	if current_lives <= 0:
		die()
	else:
		_start_invincibility()

func die() -> void:
	current_lives = 0
	GameManager.lose_seed()

func win() -> void:
	GameManager.plant_seed()

func _start_invincibility() -> void:
	is_invincible = true
	_invincibility_timer = invincibility_duration
	_flash_timer = flash_interval

func _handle_invincibility(delta: float) -> void:
	if not is_invincible:
		return

	_invincibility_timer -= delta
	_flash_timer -= delta

	if _flash_timer <= 0.0:
		visible = not visible
		_flash_timer = flash_interval

	if _invincibility_timer <= 0.0:
		is_invincible = false
		visible = true

func _is_out_of_bounds() -> bool:
	var half_width: float = player_size.x * 0.5
	var half_height: float = player_size.y * 0.5
	
	return (global_position.x + half_width < camera.limit_left or
			global_position.x - half_width > camera.limit_right or
			global_position.y + half_height < camera.limit_top or
			global_position.y - half_height > camera.limit_bottom)
