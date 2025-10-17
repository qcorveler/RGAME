extends Label

@export var full_text: String = "- Monsieur Corveler ?\n\nMonsieur Corveler, réveillez vous... C'est l'heure de votre crème anti-hémorroïdes..."
@export var char_delay := 0.05  # secondes entre chaque lettre

signal text_finished()
signal letter_added()

var current_index := 0
var timer := 0.0
var finished := false

func _ready():
	text = ""

func _process(delta):
	if current_index < full_text.length():
		timer += delta
		if timer >= char_delay:
			text += full_text[current_index]
			current_index += 1
			timer = 0.0
			letter_added.emit()
	if current_index >= full_text.length() and not finished:
		text_finished.emit()
		finished = true
