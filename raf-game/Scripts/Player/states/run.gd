extends State

func enter(_previous_state):
	player.play_animation("run")

func physics_update(delta):
	var direction = Input.get_axis("move_left", "move_right")
	
	player.skin.set_direction(direction == -1)
	
	var move_speed = player.speed
	# Gestion de la course (CTRL)
	if Input.is_action_pressed("run") and direction != 0 and not player.is_crouching:
		player.is_running = true
	else:
		player.is_running = false
	
	if player.is_running:
		move_speed *= player.run_multiplier
	
	# Vitesse x
	player.velocity.x = lerp(player.velocity.x, direction*move_speed, player.acceleration)

	if direction == 0:
		player.change_state("idle")
	elif Input.is_action_pressed("jump"):
		player.change_state("jump")
	elif Input.is_action_pressed("crouch"):
		player.change_state("crouch")
