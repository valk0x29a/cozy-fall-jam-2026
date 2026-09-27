class_name PlayerInteractions
extends Node3D

@export var interaction_range: float = 10.0
@export var pickup_sound: AudioStreamPlayer3D
@export_flags_3d_physics var interaction_mask: int

var collision;
var object: Node3D;
var is_player_hovering: bool = false;

func _process(_delta: float) -> void:
	is_player_hovering = false;
	var forward: Vector3 = -get_global_transform().basis.z;
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position + forward * interaction_range);
	query.collision_mask = interaction_mask;
	collision = get_world_3d().direct_space_state.intersect_ray(query);
	if(!collision.is_empty()):
		object = collision["collider"];
		is_player_hovering = true;
	if(Input.is_action_just_pressed("Interact")):
		if(object.has_method("player_interact")):
			object.player_interact();
	
