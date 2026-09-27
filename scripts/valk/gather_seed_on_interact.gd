class_name GatherSeedOnInteract
extends StaticBody3D

@export var deactivate_after_use: bool = true;

var used: bool = false;

func player_interact() -> void:
    if(deactivate_after_use && used): return;
    GameManager.acquire_seed();
    used = true;

func get_ui_text(): 
    if(deactivate_after_use && used): return "";
    return "Press 'E' to pick up a seed!!!";
