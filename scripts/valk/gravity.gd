extends Node
@export var gravity_acc: float = 9.8

var body: CharacterBody3D

func _ready() -> void:
	var parent = get_parent()
	if parent and parent is CharacterBody3D:
		body = parent
		
func _physics_process(delta: float) -> void:
	if body:
		# _body.velocity.y -= gravity_acc * delta
		body.move_and_collide(Vector3(0, -gravity_acc * delta, 0));