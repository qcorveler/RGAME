extends CharacterBody2D

@export var gravity: float = 1500.0

func _physics_process(delta):
	if !is_on_floor() :
		velocity.y = clamp(velocity.y + gravity*delta, -500, 500)
	
	move_and_slide()
