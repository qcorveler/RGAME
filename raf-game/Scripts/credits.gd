extends VBoxContainer

var timer := 0.0
var delay := 0.4

signal scene_ended()

func _ready():
	modulate.a = 0

func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= delay and modulate.a < 1:
		modulate.a += 0.05
		timer = 0.0
	if modulate.a >= 1:
		if timer >= 2:
			scene_ended.emit()
