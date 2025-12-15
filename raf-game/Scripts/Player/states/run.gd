extends State

func enter(_previous_state):
	player.play_animation("run")

func physics_update(delta):
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction == -1 :
		player.skin.set_direction(true)
	elif direction == 1 :
		player.skin.set_direction(false)
	
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
	elif Input.is_action_pressed("jump") and player.is_on_floor() and player.enable_jumping :
		player.change_state("jump")
	elif Input.is_action_pressed("crouch") and player.enable_crouching:
		player.change_state("crouch")
