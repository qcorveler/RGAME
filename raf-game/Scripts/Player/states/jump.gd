extends State

func enter(_previous_state):
	var jump_power = player.jump_velocity
	if player.crouch_timer > 0.2:
		var charge_ratio = player.crouch_timer / player.max_crouch_time
		jump_power += player.crouch_jump_boost * charge_ratio
		player.crouch_timer = 0.0
	player.velocity.y = jump_power
	player.play_animation("jump")

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
	
	if Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y *= 0.5  # stoppe la montée plus tôt = saut plus court
	if player.is_on_floor():
		player.change_state("idle")
