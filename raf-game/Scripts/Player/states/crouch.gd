extends State

func enter(_previous_state):
	player.set_hitbox_crouching(true)
	player.velocity.x = lerp(player.velocity.x, 0.0, player.acceleration)
	player.play_animation("crouch")

func physics_update(delta):
	player.velocity.x = lerp(player.velocity.x, 0.0, player.acceleration)
	player.is_crouching = true
	player.crouch_timer += delta
	player.crouch_timer = clamp(player.crouch_timer, 0.0, player.max_crouch_time)
	
	if Input.is_action_just_released("crouch"):
		player.change_state("idle")
	if Input.is_action_pressed("jump"):
		player.change_state("jump")

func exit():
	player.try_stand_up_smooth()
	player.is_crouching = false
	player.set_hitbox_crouching(false)
