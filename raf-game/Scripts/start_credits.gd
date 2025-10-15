extends Control

func _ready():
	pass

func _on_credits_icon_scene_ended() -> void:
	SceneTransition.go_to_scene("intro_scene")
