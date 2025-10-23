extends AudioStreamPlayer

# Joue un son de bip
func _on_intro_scene_text_letter_added() -> void:
	play_sound()
	
func play_sound() -> void :
	print("signal reçu")
	if randf() > 0.33 : # Joue le son 2 fois sur 3 de manière aléatoire
		pitch_scale = randf_range(0.8, 1.1) # randomise un peu la hauteur du son pour que ce soit plus agréable
		play()
