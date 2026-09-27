class_name GatherSeedOnInteract
extends StaticBody3D

@export var deactivate_after_use: bool = true;

var used: bool = false;

func player_interact() -> void:
	if(deactivate_after_use && used): return;
	if(GameManager.seeds_gathered - GameManager.seeds_thrown > 0): return;
	if(GameManager.is_player_done()): return;
	GameManager.acquire_seed();
	used = true;

func get_ui_text(): 
	if(GameManager.is_player_done()): return "I have rested now, time to exit the park";
	if(deactivate_after_use && used): return "";
	if(GameManager.seeds_gathered - GameManager.seeds_thrown > 0): return "I want to plant MY seed now";
	return "Time to pick up a seed!!!";
