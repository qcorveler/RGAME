extends Node2D

@onready var skin : AnimatedSprite2D = $SkinSprite

func play_anim(anim: String):
	skin.play(anim)
	
func set_direction(value):
	skin.flip_h = value

func get_skin_size():
	return skin.sprite_frames.get_frame_texture("idle", 0).get_size()
