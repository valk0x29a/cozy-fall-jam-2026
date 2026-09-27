extends Control

@export var count_texts: Array[String]

@export var plant_texts: Array[String]
var plant_text_active: bool = false;

var current_prompt_text: String;
var current_prompt_timer: float = 0;

var transition_to_black_active: bool = false;
var transition_to_black_speed: float = 1.0;
var transition_to_black_call: Callable;

var transition_to_white_active: bool = false;
var transition_to_white_speed: float = 1.0;
var transition_to_white_call: Callable;

func _ready():
	get_node("Label").text = "";
	GameManager.seeds_update.connect(update_seeds_text);
	plant_text_active = false;
	start_transition_to_white(1.5, check_for_prompt);

func check_for_prompt():
	var text: String = GameManager.get_prompt_text();
	if(text == ""): return;
	start_prompt(text, 5.0);

func _process(delta: float) -> void:
	if(transition_to_black_active):
		get_node("ColorRect").color.a += (1/transition_to_black_speed) * delta;
		if(get_node("ColorRect").color.a >= 1.0):
			if(!transition_to_black_call.is_null()): transition_to_black_call.call();
			transition_to_black_active = false;
		return;

	if(transition_to_white_active):
		get_node("ColorRect").color.a -= (1/transition_to_white_speed) * delta;
		if(get_node("ColorRect").color.a < 0):
			if(!transition_to_white_call.is_null()): transition_to_white_call.call();
			await get_tree().create_timer(0.1).timeout;
			transition_to_white_active = false;
		return;
	
	if(current_prompt_timer > 0):
		current_prompt_timer -= delta;
		get_node("Label").text = current_prompt_text; 
		plant_text_active = false;
		return;
	elif(!plant_text_active):
		get_node("Label").text = count_texts[GameManager.current_count_text] % (5 - GameManager.seeds_gathered);

	if(GameManager.is_player_done()):
		get_node("Label").text = "That's all for now, let's come back to the real world now...";
	if(GameManager.seeds_gathered - GameManager.seeds_thrown > 0 && !plant_text_active):
		get_node("Label").text = plant_texts[GameManager.current_plant_text];
		var random: RandomNumberGenerator = RandomNumberGenerator.new();
		GameManager.current_plant_text = random.randi() % (plant_texts.size() - 1);
		GameManager.current_plant_text += 1;
		plant_text_active = true;

func update_seeds_text():
	var random: RandomNumberGenerator = RandomNumberGenerator.new();
	GameManager.current_count_text = random.randi() % (count_texts.size() - 1);
	GameManager.current_count_text += 1;
	plant_text_active = false;

func set_hover_text(text: String):
	if(transition_to_black_active || transition_to_white_active): return;
	get_node("Label2").visible = true;
	get_node("Label2").text = text;

func turn_off_hover_text():
	get_node("Label2").visible = false;

func start_prompt(text: String, duration: float):
	current_prompt_text = text;
	current_prompt_timer = duration;

func start_transition_to_black(speed: float, transition_call: Callable) -> void:
	transition_to_black_speed = speed;
	transition_to_black_active = true;
	transition_to_black_call = transition_call;

func start_transition_to_white(speed: float, transition_call: Callable) -> void:
	transition_to_white_speed = speed;
	transition_to_white_active = true;
	transition_to_white_call = transition_call;