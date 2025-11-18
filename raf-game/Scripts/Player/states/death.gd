extends State

func enter(_previous_state):
	player.velocity.x = 0

func physics_update(delta):
	# Joue une animation
	
	# Quand l'animation est finie 
	player.global_position = player.checkpoint_manager.last_location
	player.change_state("idle")
	pass

func exit():
	pass
