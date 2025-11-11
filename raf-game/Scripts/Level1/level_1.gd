extends Node2D

@onready var world = $World
@onready var player = world.get_node("Player")
@onready var cam : Camera2D = player.get_node("Camera2D")
@onready var background : AnimatedSprite2D = world.get_node("Background/AnimatedBackground")
@onready var ground = $World/Ground/GroundCollision

@onready var lama = $World/Lama

@onready var dialoguePanel = $UI/DialoguePanel
@onready var scene_dialogues = DialogueLoader.dialogues["level_1"]

func _ready() :
	# Gestion du background
	var maxX = background.sprite_frames.get_frame_texture("default", 0).get_size().x*background.scale.x
	var maxY = ground.shape.a.y + 270
	print(maxX)
	# Gestion du joueur
	player.change_skin("skin_baby_raf")
	player.position.x = 100
	player.position.y = 200
	
	# Gestion du Lama
	lama.position.x = 7000
	
	# Gestion de la caméra
	cam.limit_bottom = maxY
	cam.limit_right = maxX
	cam.limit_left = 0
	
	# Gestion des premiers dialogues 
	GameState.dialogue_active = true


func _on_lama_final_position_reached() -> void:
	# Lancer les premiers dialogues
	dialoguePanel.set_lines(scene_dialogues["debut"]["lines"])
	dialoguePanel.set_active(true)
