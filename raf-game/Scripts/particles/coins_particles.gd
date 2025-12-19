extends GPUParticles2D

var played := false

func play_coin_particle():
	emitting = true
	played = true
	
func _process(delta: float) -> void:
	if played == true :
		if emitting == false: 
			queue_free()
