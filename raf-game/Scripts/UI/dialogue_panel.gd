extends Control

signal lines_finished()

@export var char_delay := 0.03  # secondes entre chaque lettre

@onready var speakerLabel := $DialogueZone/VBoxContainer/SpeakerName
@onready var dialogueLabel := $DialogueZone/VBoxContainer/DialogueText
@onready var bipSoundPlayer := $BipSoundPlayer
@onready var inputIndicator := $DialogueZone/InputIndicator

var lines
var line_index : int = 0

var timer := 0.0
var finished := false

var active := false

func set_speaker_name(speaker_name: String):
	speakerLabel.text = speaker_name
	
func set_dialogue_text(dialogue_text: String):
	dialogueLabel.text = dialogue_text

func set_lines(_lines):
	lines = _lines
	set_speaker_name(lines[line_index]["speaker"])
	set_dialogue_text(lines[line_index]["text"])
	dialogueLabel.visible_ratio = 0 # Rien n'est visible au début

func set_active(value):
	active = value
	GameState.dialogue_active = value
	visible = value
	line_index = 0
	inputIndicator.set_active(false)
	inputIndicator.set_black(value)
	finished = false

func next_dialogue_line():
	line_index += 1
	if line_index >= lines.size():
		set_speaker_name("")
		set_dialogue_text("")
		lines_finished.emit()
		set_active(false)
		line_index = 0
		return
	set_speaker_name(lines[line_index]["speaker"])
	set_dialogue_text(lines[line_index]["text"])

func _ready() -> void:
	dialogueLabel.visible_ratio = 0 # Rien n'est visible au début
	inputIndicator.set_icon(load("res://Img/util/keyboard_space.png"))
	inputIndicator.set_active(false)
	inputIndicator.set_black(true) # Mets l'icon de l'indicateur en noir

func _input(event):
	if event.is_action_pressed("ui_accept") and finished :
		await fade_out_texts(1)
		dialogueLabel.modulate.a = 1
		finished = false
		dialogueLabel.visible_ratio = 0 # Rien n'est visible au début
		inputIndicator.set_active(false)
		next_dialogue_line()

func _process(delta: float) :
	timer += delta
	if dialogueLabel.visible_ratio < 1 :
		if timer >= char_delay:
			dialogueLabel.visible_characters += 1
			bipSoundPlayer.play_sound()
			timer = 0.0
	else:
		if not finished :
			inputIndicator.set_active(true)
			finished = true

func fade_out_texts(duration:float):
	var tween = get_tree().create_tween()
	tween.tween_property(dialogueLabel, "modulate:a", 0.0, duration)
	await tween.finished
