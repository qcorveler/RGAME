extends Node2D

@onready var background = $Background
@onready var animatedBg : AnimatedSprite2D = background.get_node("AnimatedBackground")
@onready var ground : StaticBody2D = $Ground
@onready var groundSprite : Sprite2D = ground.get_node("GroundSprite")
@onready var groundCollision : CollisionShape2D = ground.get_node("GroundCollision")
@onready var wallRight : StaticBody2D = $WallRight
@onready var wallRightCollision : CollisionShape2D = wallRight.get_node("CollisionShape2D")
@onready var wallLeft : StaticBody2D = $WallLeft
@onready var wallLeftCollision : CollisionShape2D = wallLeft.get_node("CollisionShape2D")

@onready var player = $PlayerRafVieux
@onready var cam : Camera2D = player.get_node("Camera2D")

func _ready():
	# Récupération du ratio
	var screen_size = get_viewport_rect().size
	var tex_size = animatedBg.sprite_frames.get_frame_texture("LevelIntro", 0).get_size()
	var ratio = max(screen_size.x / tex_size.x, screen_size.y / tex_size.y)

	# Gestion du fond animé
	animatedBg.scale = Vector2(ratio, ratio)
	
	# Gestion du sol
	groundSprite.scale = Vector2(ratio, ratio)
	var groundY = screen_size.y - groundSprite.texture.get_size().y*ratio
	groundSprite.position.y = groundY
	groundCollision.shape.set("a", Vector2(0, groundY))
	groundCollision.shape.set("b", Vector2(tex_size.x*ratio, groundY))
	print(groundCollision.shape.get("a"))
	print(groundCollision.position)
	print(groundSprite.position)
	
	# Gestion du mur de droite
	var maxX = (groundSprite.texture.get_size().x - 30)*ratio
	wallRightCollision.shape.set("a", Vector2(maxX, 0))
	wallRightCollision.shape.set("b", Vector2(maxX, 5000))
	
	# Gestion du mur de gauche
	var minX = 30
	wallLeftCollision.shape.set("a", Vector2(minX, 0))
	wallLeftCollision.shape.set("b", Vector2(minX, 5000))
	
	# Gestion de la caméra
	cam.limit_bottom = get_viewport_rect().size.y
	cam.limit_right = maxX + 30*ratio
	
	# Gestion du joueur
	player.set_skin_size(ratio/3)
