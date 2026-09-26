extends CharacterBody3D
class_name PlayerController

@export var move_speed = 5.0

const SENSITIVITY = 0.004

const BOB_FREQ = 7.2
const BOB_AMP = 0.01
var t_bob = 0.0

var last_frame_mouse_pos: Vector3
var mouse_input: Vector2
var camera_base_offset: Vector3 # zapamiętany oryginalny lokalny offset kamery

var current_sound_time: float
@export var footstep_repeat_time: float
@export var footstep_sound: AudioStreamPlayer3D

@onready var head = $Head
@onready var collision_shape = $CollisionShape3D

var movement_is_blocked := false
var camera_is_blocked := false

@export var load_save_on_ready: bool = true;

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if !head: print("NO CAMERA DETECTED!!!")
	camera_base_offset = head.transform.origin
	current_sound_time = footstep_repeat_time
	if(load_save_on_ready):
		GameManager.load_save();

func _physics_process(delta: float) -> void:
	var input_dir = Vector3.ZERO
	
	if (!movement_is_blocked):
		input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		input_dir.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	
	if input_dir != Vector3.ZERO:
		input_dir = input_dir.normalized()

	var direction := Vector3.ZERO
	if !head: print("No head node found!!!");
	var head_basis: Basis = transform.basis
	var forward: Vector3 = -head_basis.z
	var right: Vector3 = head_basis.x
		# Input: input_dir.z dodatnie przy S, ujemne przy W; invertujemy aby W dawało +forward
	var move_vec: Vector3 = right * input_dir.x + forward * (-input_dir.z)
	move_vec.y = 0.0
	if move_vec != Vector3.ZERO:
		direction = move_vec.normalized()
		current_sound_time -= delta
		if current_sound_time <= 0 && footstep_sound != null:
			footstep_sound.play()
			current_sound_time = footstep_repeat_time
		
	if input_dir != Vector3.ZERO:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = lerp(velocity.x, 0.0, delta * 7.0)
		velocity.z = lerp(velocity.z, 0.0, delta * 7.0)


	# t_bob += delta * velocity.length();# * float(is_on_floor())
	# head.transform.origin = camera_base_offset + _headbob(t_bob)
	
	move_and_slide()

func _process(delta: float) -> void:
	t_bob += delta * velocity.length()# * float(is_on_floor())
	head.transform.origin = camera_base_offset + _headbob(t_bob)

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == Key.KEY_SPACE:
			var sound_pos = to_global(Vector3(0, 0, -1))

func _unhandled_input(event):
	if (camera_is_blocked): return;
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENSITIVITY)
		head.rotate_x(-event.relative.y * SENSITIVITY)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	
