extends Control

@export var pulse_speed: float = 3.0
@export var alpha_min: float = 0.3
@export var alpha_max: float = 1.0
@export var scale_min: float = 1.2
@export var scale_max: float = 1.3

var t := 0.0
@onready var icon := $InputIcon

var active := false
var inversed_color := false

func set_inversed_color(value: bool):
	inversed_color = value
	icon.material.set("shader_param/invert_colors", value)

func set_active(value: bool):
	active = value
	visible = value
	t = 0.0

func _ready():
	icon.modulate.a = alpha_max
	icon.scale = Vector2.ONE
	set_inversed_color(inversed_color)

func _physics_process(delta):
	if not active:
		return
	t += delta * pulse_speed
	
	# Clignotement alpha
	var alpha = lerp(alpha_min, alpha_max, (sin(t) + 1.0) / 2.0)
	icon.modulate.a = alpha
	
	# Effet de pulsation (grossissement doux)
	var scale_factor = lerp(scale_min, scale_max, (sin(t) + 1.0) / 2.0)
	icon.scale = Vector2(scale_factor, scale_factor)
