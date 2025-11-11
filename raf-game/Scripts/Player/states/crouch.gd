extends State

func enter(_previous_state):
	player.velocity.x = 0
	player.play_animation("idle") # crouch

func physics_update(delta):
	player.is_crouching = true
	player.crouch_timer += delta
	player.crouch_timer = clamp(player.crouch_timer, 0.0, player.max_crouch_time)
	
	if Input.is_action_just_released("crouch"):
		player.change_state("idle")
	if Input.is_action_pressed("jump"):
		player.change_state("jump")

func exit():
	player.is_crouching = false
