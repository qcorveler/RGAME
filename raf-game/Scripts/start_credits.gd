extends Control

func _ready():
	pass

func _on_v_box_container_scene_ended() -> void:
	SceneTransition.go_to_scene("Cinematiques/intro_scene")
