extends Control

var text_finished : bool = false

func _input(event):
	if event.is_action_pressed("ui_accept") and text_finished :
		SceneTransition.go_to_scene("Level")

func _on_label_text_finished() -> void:
	text_finished = true 
