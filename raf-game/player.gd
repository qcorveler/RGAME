extends CharacterBody2D

@export var gravity = 1500
@export var speed = 200
@export var jump_velocity = -1000

@export var acceleration = 0.2

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta) :
	if !is_on_floor() :
		velocity.y = clamp(velocity.y + gravity*delta, -500, 500)
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction !=0 :
		sprite.flip_h = (direction == -1)
	
	velocity.x = lerp(velocity.x, direction*speed, acceleration)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	update_animation(direction)
	move_and_slide()
	
func update_animation(direction):
	if is_on_floor() :
		if direction == 0 :
			sprite.play("idle")
		else :
			sprite.play("run")
	else:
		sprite.play("jump")
