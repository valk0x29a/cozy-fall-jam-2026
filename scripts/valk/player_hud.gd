extends Control

func _process(delta: float) -> void:
    if(GameManager.seeds_gathered - GameManager.seeds_thrown > 0):
        get_node("Label").text = "Time to plant/throw the seed!!!";
