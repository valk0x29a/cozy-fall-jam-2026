extends Node

var seeds_gathered: int = 0;
var seeds_thrown: int = 0;
var seeds_planted: int = 0;

var first_launch: bool = true;

var player_saved_position: Vector3 = Vector3.ZERO;
var player_saved_rotation: Vector3 = Vector3.ZERO;

var camera_saved_rotation: Vector3 = Vector3.ZERO;

var seeds_used: Array[bool] = [false];

func load_save():
	if(first_launch): first_launch = false; return;
	var player: Node3D = get_node("/root").get_child(1).get_node("Player");
	player.global_position = player_saved_position;
	player.global_rotation = player_saved_rotation;
	player.get_node("Head").global_rotation = camera_saved_rotation;

	var seeds := get_tree().get_nodes_in_group("seeds");
	for i in range(seeds.size()):
		var seed_gather: GatherSeedOnInteract = seeds[i] as GatherSeedOnInteract;
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
		seeds_used[i] = seed_gather.used;

func acquire_seed() -> void:
	seeds_gathered += 1;

func throw_seed() -> void:
	seeds_thrown += 1;

func plant_seed() -> void:
	seeds_planted += 1;
	get_tree().change_scene_to_file("res://scenes/ValkScene.tscn");

func lose_seed() -> void:
	get_tree().change_scene_to_file("res://scenes/ValkScene.tscn");
