extends Node2D

@onready var world = $World
@onready var background = world.get_node("Background")
@onready var animatedBg : AnimatedSprite2D = background.get_node("AnimatedBackground")
@onready var ground : StaticBody2D = world.get_node("Ground")
@onready var groundSprite : Sprite2D = ground.get_node("GroundSprite")
@onready var groundCollision : CollisionShape2D = ground.get_node("GroundCollision")
@onready var wallRight : StaticBody2D = world.get_node("WallRight")
@onready var wallRightCollision : CollisionShape2D = wallRight.get_node("CollisionShape2D")
@onready var wallLeft : StaticBody2D = world.get_node("WallLeft")
@onready var wallLeftCollision : CollisionShape2D = wallLeft.get_node("CollisionShape2D")

@onready var player = world.get_node("PlayerRafVieux")
@onready var cam : Camera2D = player.get_node("Camera2D")

@onready var infirmier = world.get_node("Infirmier")


@onready var ui = $UI

@onready var dialoguePanel = ui.get_node("DialoguePanel")
@onready var inputIndicator = ui.get_node("InputIndicator")
@onready var screen = ui.get_node("Screen")

var dialogue_index := 0
@onready var scene_dialogues = DialogueLoader.dialogues["level_intro"]

var screen_reached : bool = false

# Variable permettant de savoir si le joueur se trouve devant un objet interactif
var saint_malo : bool = false
var enki_bilal : bool = false
var minecraft : bool = false
var vieille_nue : bool = false
var computer : bool = false
var storage : bool = false

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
	player.set_skin_scale(ratio/3)
	player.position = Vector2(700, groundY - (player.get_skin_size().y) * (ratio/3) - 20)
	
	# Gestion de l'infirmier
	infirmier.apply_scale(Vector2(ratio/2,ratio/2))
	infirmier.position = Vector2(200, groundY - (infirmier.get_skin_size().y) * (ratio/2) - 20)
	
	# Gestion de l'indicateur d'input
	inputIndicator.set_active(false)
	inputIndicator.set_black(false)
	
	# Gestion du panel de dialogue
	dialoguePanel.set_active(false)
	
	# Gestion de l'écran d'ordinateur
	screen.set_visible(false)

func _process(_delta):
	# Tableau Saint Malo
	saint_malo = 850 <= player.position.x and player.position.x <= 1200 and !screen_reached
	enki_bilal = 3250 <= player.position.x and player.position.x <= 3600
	vieille_nue = 4340 <= player.position.x and player.position.x <= 4750
	minecraft = 5050 <= player.position.x and player.position.x <= 5500
	storage = 950 <= player.position.x and player.position.x <=1100 and screen_reached
	computer = player.position.x >= 7300
	
	if saint_malo or enki_bilal or vieille_nue or minecraft or computer or storage :
		inputIndicator.set_icon(load("res://Img/util/keyboard_a.png"))
		inputIndicator.set_active(true)
	else :
		inputIndicator.set_active(false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact_a") and !GameState.wait_player_input:
		if saint_malo :
			dialoguePanel.set_lines(scene_dialogues["saint_malo"]["lines"])
			dialoguePanel.set_active(true)
		if enki_bilal :
			dialoguePanel.set_lines(scene_dialogues["enki_bilal"]["lines"])
			dialoguePanel.set_active(true)
		if vieille_nue :
			dialoguePanel.set_lines(scene_dialogues["vieille_nue"]["lines"])
			dialoguePanel.set_active(true)
		if minecraft :
			dialoguePanel.set_lines(scene_dialogues["minecraft"]["lines"])
			dialoguePanel.set_active(true)
		if computer :
			dialoguePanel.set_lines(scene_dialogues["computer"]["lines"])
			dialoguePanel.set_active(true)
			if !GameState.wait_player_input :
				screen_reached = true
				screen.toggle_visible()
		if storage :
			dialoguePanel.set_lines(scene_dialogues["storage"]["lines"])
			dialoguePanel.set_active(true)
