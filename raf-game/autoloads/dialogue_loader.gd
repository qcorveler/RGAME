extends Node

var dialogues = {}

#signal dialogues_loaded

func _ready():
	load_dialogues()

func load_dialogues():
	var file = FileAccess.open("res://Dialogues/Dialogues.json", FileAccess.READ)
	if file:
		var content = file.get_as_text()
		dialogues = JSON.parse_string(content)
		if dialogues == null:
			push_error("Erreur de parsing JSON !")
		else:
			#dialogues_loaded.emit()
			print("Dialogues chargés :", dialogues.keys())
	else:
		push_error("Impossible de lire dialogues.json")
