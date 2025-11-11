extends CharacterBody2D

signal final_position_reached()

@export var gravity: float = 1500.0
@export var player_path: NodePath
@export var speed: float = 0.4
@export var follow_distance: float = 200.0  # distance à garder du joueur
var acceleration : float = 0.2

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_node(player_path)
@onready var jumpsoundPlayer = $JumpSoundPlayer
var timer : float = 0

var on_final_position : bool = false

func _physics_process(delta):
	if !is_on_floor() :
		velocity.y = clamp(velocity.y + gravity*delta, -500, 500)
	
	# Calcule la distance au joueur
	var direction = player.global_position.x - global_position.x
	
	sprite.flip_h = direction < 0
	
	if on_final_position:
		return
	print(position.x)
	timer += delta
	# Si trop loin → avancer vers le joueur
	if abs(direction) > follow_distance:
		velocity.x = lerp(velocity.x, direction*speed, acceleration)
		if timer > 0.55 :
			jumpsoundPlayer.play()
			timer = 0
		update_animation(1)
	else : 
		velocity.x = lerp(velocity.x, 0.0, acceleration)
		update_animation(0)
		if velocity.x <= 0.1 :
			on_final_position = true
			final_position_reached.emit()
	move_and_slide()

func update_animation(direction):
	if is_on_floor() :
		if direction == 0 :
			sprite.play("idle")
		else :
			sprite.play("jump")
	else :
		sprite.play("idle")
