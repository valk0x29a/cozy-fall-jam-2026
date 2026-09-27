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
	GameManager.seeds_update.connect(update_seeds_text);
	plant_text_active = false;
	if(!GameManager.intro_prompt_said):
		start_prompt("Hmmm, I'm soo tired, let's chill out in this park", 5.0)
		GameManager.intro_prompt_said = true;
	start_transition_to_white(2.5, Callable());

func _process(delta: float) -> void:
	if(transition_to_black_active):
		get_node("ColorRect").color.a += (1/transition_to_black_speed) * delta;
		if(get_node("ColorRect").color.a >= 1.0):
			if(!transition_to_black_call.is_null()): transition_to_black_call.call();
			transition_to_black_active = false;

	if(transition_to_white_active):
		get_node("ColorRect").color.a -= (1/transition_to_white_speed) * delta;
		if(get_node("ColorRect").color.a < 0):
			if(!transition_to_white_call.is_null()): transition_to_white_call.call();
			transition_to_white_active = false;
	
	if(current_prompt_timer > 0):
		current_prompt_timer -= delta;
		get_node("Label").text = current_prompt_text; 
		plant_text_active = false;
		return;
	elif(!plant_text_active):
		get_node("Label").text = count_texts[GameManager.current_count_text] % (5 - GameManager.seeds_gathered);

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
	get_node("Label2").visible = true;
	get_node("Label2").text = text;

func turn_off_hover_text():
	get_node("Label2").visible = false;

func start_prompt(text: String, duration: int):
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