extends Node

@export var player : CharacterBody2D
var last_location

func _ready() -> void:
	last_location = player.global_position
