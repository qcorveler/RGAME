extends Node2D

@onready var skin = $SkinSprite

func play_anim(anim: String):
	skin.play(anim)
	
func set_direction(value):
	skin.flip_h = value
