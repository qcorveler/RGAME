extends AnimatedSprite2D

func play_dust():
	# 1. on détache l’animation du joueur
	visible = true
	play("dust")

func _on_animation_finished():
	queue_free()
