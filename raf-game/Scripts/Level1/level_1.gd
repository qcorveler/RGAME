extends Node2D

@onready var world = $World
@onready var player = world.get_node("Player")
@onready var cam : Camera2D = player.get_node("Camera2D")
@onready var background : AnimatedSprite2D = world.get_node("Background/AnimatedBackground")
@onready var ground = $World/Ground/GroundCollision

func _ready() :
	# Gestion du background
	var maxX = background.sprite_frames.get_frame_texture("default", 0).get_size().x*background.scale.x
	var maxY = ground.shape.a.y + 130
	
	print(maxY)
	# Gestion du joueur
	player.change_skin("skin_baby_raf")
	print(player.position.y)
	
	# Gestion de la caméra
	cam.limit_bottom = maxY
	cam.limit_right = maxX
	cam.limit_left = 0
