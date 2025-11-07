extends PointLight2D

var base_energy = 1.0
@export var base_texture_scale : float = 1.0
var t = 0.0

func _process(delta):
	t += delta
	energy = base_energy + sin(t * 2.0) * 0.1
	texture_scale = base_texture_scale + sin(t * 2.0) * 0.02
