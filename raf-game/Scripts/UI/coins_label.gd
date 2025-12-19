extends Control

@onready var label := $Label

func _process(delta: float) -> void:
	label.text = "Pièces : " + str(GameState.coins)
