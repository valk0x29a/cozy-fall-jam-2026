class_name PhysicsComponent
extends Node

@export_group("Mass and Limits")
@export var mass: float = 0.5
@export var maximum_speed: float = 400.0

@export_group("External Forces")
@export var gravity_force: float = 300.0
@export var gust_force: float = 500.0
@export var waterfall_force: float = 100.0
@export var blow_force: float = 500.0

@export_group("Resistance and Friction")
@export var ground_friction: float = 600.0
@export var air_resistance: float = 100.0
@export var water_resistance: float = 400.0


func calculate_velocity(current_velocity: Vector2, on_floor: bool, in_water: bool, blow_direction: Vector2, gust_direction: Vector2, waterfall_direction: Vector2, delta: float) -> Vector2:
	var velocity: Vector2 = current_velocity
	var safe_mass: float = maxf(mass, 0.01)

	if in_water:
		var effective_water_decelration: float = (water_resistance / safe_mass) * delta
		velocity = velocity.move_toward(Vector2.ZERO, effective_water_decelration)
		
	elif on_floor:
		velocity.x = move_toward(velocity.x, 0.0, ground_friction * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, air_resistance * delta)

	velocity.y += gravity_force * delta
	velocity += (blow_direction * blow_force / safe_mass) * delta
	velocity += (gust_direction * gust_force / safe_mass) * delta
	velocity += (waterfall_direction * waterfall_force / safe_mass) * delta

	velocity = velocity.clamp(Vector2(-maximum_speed, -maximum_speed), Vector2(maximum_speed, maximum_speed))

	return velocity
