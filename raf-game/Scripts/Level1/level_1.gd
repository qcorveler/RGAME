extends Node2D

@onready var world = $World
@onready var player = $World/Player
@onready var cam : Camera2D = $World/Player/Camera2D
@onready var background : AnimatedSprite2D = $World/Background/AnimatedBackground
@onready var ground = $World/Ground/GroundCollision

@onready var lama = $World/Lama

@onready var dialoguePanel = $UI/DialoguePanel
@onready var scene_dialogues = DialogueLoader.dialogues["level_1"]

@onready var tilemap = $World/TileMap
@onready var wallLayer : TileMapLayer = $World/TileMap/WallAndPlateformLayer
@onready var groundLayer : TileMapLayer = $World/TileMap/GroundLayer
@onready var trapLayer : TileMapLayer = $World/TileMap/TrapLayer
@onready var indicationLayer : TileMapLayer = $World/TileMap/IndicationLayer

@onready var inputIndicator = $UI/InputIndicator

var player_in_lama_zone : bool = false
var sign_zone = null

func _ready() :
	# Gestion du background
	var maxX = background.sprite_frames.get_frame_texture("default", 0).get_size().x*background.scale.x
	var maxY = ground.shape.a.y + 270
	world.color = Color(0.0, 0.0, 0.0)
	
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
	inputIndicator.set_black(false)
	
	# Gestion des plateformes 
	set_platforms_visible(false) # Pour pas qu'on les voit quand le lama se déplace

func _process(_delta: float) -> void:
	player_in_lama_zone = player.global_position.distance_to(lama.global_position) < lama.zone_size
	sign_zone = null
	for sign_position in indicationLayer.signs_info :
		if sign_position == Vector2i(indicationLayer.local_to_map(indicationLayer.to_local(player.global_position)))  :
			sign_zone = indicationLayer.signs_info[sign_position]
	
	if get_indicator_input() == null:
		inputIndicator.set_active(false)
	else :
		inputIndicator.set_icon(get_indicator_input())
		inputIndicator.set_active(true)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact_a") and !GameState.wait_player_input:
		var dialogue = get_dialogue()
		if dialogue == null :
			return
		else :
			player.change_state("idle")
			dialoguePanel.set_lines_and_activate(scene_dialogues[dialogue]["lines"])

func set_platforms_visible(value : bool) -> void:
	wallLayer.enabled = value
	groundLayer.collision_enabled = value
	trapLayer.enabled = value

func get_indicator_input() :
	if player_in_lama_zone :
		return "a"
	elif sign_zone != null :
		return "a"
	else :
		return null
		
func get_dialogue():
	if player_in_lama_zone :
		return "lama_help"
	elif sign_zone != null :
		return sign_zone
	else:
		return null

func _on_lama_final_position_reached() -> void:
	# Lancer les premiers dialogues
	dialoguePanel.set_lines_and_activate(scene_dialogues["debut"]["lines"])
	dialoguePanel.set_active(true)
	set_platforms_visible(true)
