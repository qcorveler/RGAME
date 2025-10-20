extends Control

var timer : float = 0.0
var framerate := 3
var chambre := 0

var image0 := preload("res://Img/Cinematiques/Ehpad chambre -0.png")
var image1 := preload("res://Img/Cinematiques/Ehpad chambre -1.png")

var dialogue_index := 0

var scene_dialogues = DialogueLoader.dialogues["chambre_ehpad"]["lines"]

@onready var display = $DisplayRect
@onready var dialoguePanel = $DialoguePanel

func _ready() -> void:
	dialoguePanel.set_speaker_name(scene_dialogues[dialogue_index]["speaker"])
	dialoguePanel.set_dialogue_text(scene_dialogues[dialogue_index]["text"])

func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= 1.0/framerate :
		move_img()
		timer = 0

func move_img():
	if chambre == 0 :
		display.texture = image0
	elif chambre == 1 :
		display.texture = image1
	chambre = (chambre+1)%2

func _on_dialogue_panel_next_dialogue() -> void:
	dialogue_index += 1
	if dialogue_index < scene_dialogues.size() :
		dialoguePanel.set_speaker_name(scene_dialogues[dialogue_index]["speaker"])
		dialoguePanel.set_dialogue_text(scene_dialogues[dialogue_index]["text"])
	else :
		dialoguePanel.set_speaker_name("")
		dialoguePanel.set_dialogue_text("")
		SceneTransition.go_to_scene("Levels/LevelIntro")
	
