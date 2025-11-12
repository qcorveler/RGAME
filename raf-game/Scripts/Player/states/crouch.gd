extends State

func enter(_previous_state):
	player.collisionBox.position.y = 14.0
	player.collisionBox.shape.size.y = 80.0
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
	player.is_crouching = false
	player.collisionBox.position.y = 4.0
	player.collisionBox.shape.size.y = 100.0
