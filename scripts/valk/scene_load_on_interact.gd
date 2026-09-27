extends StaticBody3D

@export var scene_name: StringName;
@export var save_player_position: bool = true;
@export var throw_seed_on_interact: bool = true;
@export var require_not_thrown_seed: bool = true;

func player_interact() -> void:
    if(require_not_thrown_seed && GameManager.seeds_gathered - GameManager.seeds_thrown <= 0): return;
    if(save_player_position): GameManager.create_save();
    if(throw_seed_on_interact): GameManager.throw_seed();
    get_tree().change_scene_to_file("res://scenes/" + scene_name + ".tscn")

func get_ui_text() -> String: 
    if(require_not_thrown_seed && GameManager.seeds_gathered - GameManager.seeds_thrown <= 0): return "You don't have any seeds to plant!!!";
    return "Press 'E' to plant your seed!!!";