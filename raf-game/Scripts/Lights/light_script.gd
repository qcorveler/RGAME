extends PointLight2D

var base_energy := 0.0
var final_energy := 1.0
var base_texture_scale := 0.0
@export var final_texture_scale : float = 1.0
var t = 0.0

var allumage_fini := false

func _ready() -> void:
	base_energy = 0.0
	base_texture_scale = 0.0

func _process(delta):
	t += delta
	energy = base_energy + sin(t * 2.0) * 0.1
	texture_scale = base_texture_scale + sin(t * 2.0) * 0.02
	if not allumage_fini : 
		base_energy = lerp(base_energy, final_energy, 0.01)
		base_texture_scale = lerp(base_texture_scale, final_texture_scale, 0.01)
		if (abs(base_texture_scale - final_texture_scale) < 0.001) and (abs(base_energy - final_energy) < 0.001):
			allumage_fini = true
