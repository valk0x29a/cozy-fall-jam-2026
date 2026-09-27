extends Node

var seeds_gathered: int = 0;
var seeds_thrown: int = 0;
var seeds_planted: int = 0;

var first_launch: bool = true;

var player_saved_position: Vector3 = Vector3.ZERO;
var player_saved_rotation: Vector3 = Vector3.ZERO;

var camera_saved_rotation: Vector3 = Vector3.ZERO;

var seeds_used: Array[bool] = [false];

var intro_prompt_said: bool = false;

signal seeds_update

var current_plant_text: int = 0;
var current_count_text: int = 0;

var last_throw_failed: bool = false;
var last_throw_succeded: bool = false;

func is_player_done() -> bool: return seeds_thrown == 5;

func get_prompt_text() -> String:
	if(!intro_prompt_said): 
		intro_prompt_said = true; 
		return "Hmmm, I'm soo tired, let's chill out in this park";
	if(last_throw_failed):
		last_throw_failed = false;
		return "Damn, that was such a beatiful seed...";
	if(last_throw_succeded):
		last_throw_succeded = false;
		return "Hell Yeah, I am as accurate as Meow";
	return "";

func start_transition_to_black(speed: float, transition_call: Callable) -> void:
	var player: PlayerController = get_node("/root").get_child(1).get_node("Player");
	player.player_hud.start_transition_to_black(speed, transition_call);

func load_save():
	if(first_launch): first_launch = false; return;
	var player: Node3D = get_node("/root").get_child(1).get_node("Player");
	player.global_position = player_saved_position;
	player.global_rotation = player_saved_rotation;
	player.get_node("Head").global_rotation = camera_saved_rotation;

	var seeds := get_tree().get_nodes_in_group("seeds");
	for i in range(seeds.size()):
		var seed_gather: GatherSeedOnInteract = seeds[i] as GatherSeedOnInteract;
		if(seed_gather == null): print(seeds[i].name); continue;
		seed_gather.used = seeds_used[i];

func create_save():
	var player: Node3D = get_node("/root").get_child(1).get_node("Player");
	player_saved_position = player.global_position;
	player_saved_rotation = player.global_rotation;
	camera_saved_rotation = player.get_node("Head").global_rotation;

	var seeds := get_tree().get_nodes_in_group("seeds");
	seeds_used.resize(seeds.size());
	for i in range(seeds.size()):
		var seed_gather: GatherSeedOnInteract = seeds[i] as GatherSeedOnInteract;
		if(seed_gather == null): print(seeds[i].name); continue;
		seeds_used[i] = seeds[i].used;

func acquire_seed() -> void:
	seeds_gathered += 1;
	seeds_update.emit();

func throw_seed() -> void:
	seeds_thrown += 1;

func plant_seed() -> void:
	seeds_planted += 1;
	last_throw_succeded = true;
	get_tree().change_scene_to_file("res://scenes/main.tscn");

func lose_seed() -> void:
	last_throw_failed = true;
	get_tree().change_scene_to_file("res://scenes/main.tscn");
