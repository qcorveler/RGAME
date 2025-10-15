extends AudioStreamPlayer2D

# Joue un son de bip
func _on_label_letter_added() -> void:
	if randf() > 0.25 : # Joue le son 3 fois sur 4 de manière aléatoire
		pitch_scale = randf_range(0.8, 1.1) # randomise un peu la hauteur du son pour que ce soit plus agréable
		play()
