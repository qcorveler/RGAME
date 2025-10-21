extends Control

var timer : float = 0.0
var framerate := 3
var chambre := 0

var image0 := preload("res://Img/Cinematiques/Ehpad chambre -0.png")
var image1 := preload("res://Img/Cinematiques/Ehpad chambre -1.png")

var scene_dialogues = DialogueLoader.dialogues["chambre_ehpad"]["lines"]

@onready var display = $DisplayRect
@onready var dialoguePanel = $DialoguePanel

func _ready() -> void:
	dialoguePanel.set_active(true)
	dialoguePanel.set_lines(scene_dialogues)

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
	

func _on_dialogue_panel_lines_finished() -> void:
	SceneTransition.go_to_scene("Levels/LevelIntro")
