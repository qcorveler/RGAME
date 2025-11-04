extends Node2D

@onready var world = $World
@onready var player = world.get_node("Player")

func _ready() :
	# Gestion du joueur
	player.change_skin("skin_baby_raf")
