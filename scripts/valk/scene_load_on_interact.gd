extends StaticBody3D

@export var scene_name: StringName;
@export var save_player_position: bool = true;
@export var throw_seed_on_interact: bool = true;
@export var require_not_thrown_seed: bool = true;

func player_interact() -> void:
	if(require_not_thrown_seed && GameManager.seeds_gathered - GameManager.seeds_thrown <= 0): return;
	if(!GameManager.is_player_done() && !throw_seed_on_interact): return;
	if(save_player_position): GameManager.create_save();
	if(throw_seed_on_interact): GameManager.throw_seed();
	GameManager.start_transition_to_black(1.0, load_scene);

func load_scene():
	if(throw_seed_on_interact):
		get_tree().change_scene_to_file("res://scenes/" + scene_name + str(GameManager.seeds_gathered) + ".tscn");
	elif(GameManager.is_player_done()):
		get_tree().change_scene_to_file("res://scenes/" + scene_name + ".tscn")

func get_ui_text() -> String: 
	if(GameManager.is_player_done() && throw_seed_on_interact): return "I have rested now, time to exit the park";
	if(GameManager.is_player_done() && !throw_seed_on_interact): return "Time to return to the real world...";
	if(!GameManager.is_player_done() && !throw_seed_on_interact): return "it's not a time to exit right now. I have to give myself some time for rest"
	if(require_not_thrown_seed && GameManager.seeds_gathered - GameManager.seeds_thrown <= 0): return "I don't have any seeds to plant!!!";
	return "Let's plant this seed!!!";
