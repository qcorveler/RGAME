extends Control

var text_finished : bool = false

func _ready() -> void:
	$InputIndicator.set_active(false)

func _input(event):
	if event.is_action_pressed("ui_accept") and text_finished :
		SceneTransition.go_to_scene("Cinematiques/ehpad_cinematique")

func _on_intro_scene_text_text_finished() -> void:
	text_finished = true 
	$InputIndicator.set_active(true)
