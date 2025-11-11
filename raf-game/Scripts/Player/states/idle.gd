extends State

func enter(_previous_state):
	player.velocity.x = lerp(player.velocity.x, 0.0, player.acceleration)
	player.play_animation("idle")

func physics_update(delta):
	player.velocity.x = lerp(player.velocity.x, 0.0, player.acceleration)
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
		player.change_state("run")
	elif Input.is_action_pressed("jump"):
		player.change_state("jump")
	elif Input.is_action_pressed("crouch"):
		player.change_state("crouch")
