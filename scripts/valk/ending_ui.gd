extends Node

func get_ending_text() -> String:
	match GameManager.seeds_planted:
		0: return "0 out of 5 seeds planted.\n I hope your character didn't go into depression for this"
		1: return "1 out of 5 seeds planted.\n Well, at least that's something. Hope your character enjoyed the view"
		2: return "2 out of 5 seeds planted.\n A small achievement, your character may have regenerated a little"
		3: return "3 out of 5 seeds planted.\n That's quite something. Your character is feeling better after this trip"
		4: return "4 out of 5 seeds planted.\n Damn, your character may start coming into the park more often"
		5: return "5 out of 5 seeds planted.\n You knocked it out of the park. 100% your character will come here more often"
	return "Damn, this game got an error, sorry but I don't know if your character has felt better after throing the seeds"

func _ready():
	get_node("Label").text = get_ending_text();
