extends Control

func _process(delta: float) -> void:
	if(GameManager.seeds_gathered - GameManager.seeds_thrown > 0):
		get_node("Label").text = "Time to plant/throw the seed!!!";


func set_hover_text(text: String):
	get_node("Label2").visible = true;
	get_node("Label2").text = text;

func turn_off_hover_text():
	get_node("Label2").visible = false;
