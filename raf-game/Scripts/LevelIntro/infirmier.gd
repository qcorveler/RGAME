extends CharacterBody2D

@export var player_path: NodePath
@export var gravity: float = 100.0
@export var speed: float = 0.4
@export var follow_distance: float = 300.0  # distance à garder du joueur
var acceleration : float = 0.2

@onready var player = get_node(player_path)
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	if !is_on_floor() :
		velocity.y = clamp(velocity.y + gravity*delta, -1000, 1000)
	
	if not player:
		return
	
	# Calcule la distance au joueur
	var direction = player.global_position.x - global_position.x
	
	sprite.flip_h = direction < 0
	
	# Si trop loin → avancer vers le joueur
	if abs(direction) > follow_distance:
		velocity.x = lerp(velocity.x, direction*speed, acceleration)
		update_animation(1)
	else : 
		velocity.x = lerp(velocity.x, 0.0, acceleration)
		update_animation(0)
	
	move_and_slide()
	
func update_animation(direction):
	if is_on_floor() :
		if direction == 0 :
			sprite.play("idle")
		else :
			sprite.play("walk")
	else :
		sprite.play("idle")
		
func get_skin_size():
	return sprite.sprite_frames.get_frame_texture("idle", 0).get_size()
