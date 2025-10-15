extends Sprite2D

var timer := 0.0
var delay := 0.4

signal scene_ended()

func _ready():
	modulate.a = 0
	@warning_ignore("integer_division")
	position.x = DisplayServer.window_get_size().x / 2
	@warning_ignore("integer_division")
	position.y = DisplayServer.window_get_size().y / 2
	

func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= delay and modulate.a < 1:
		modulate.a += 0.05
		timer = 0.0
	if modulate.a >= 1:
		if timer >= 2:
			scene_ended.emit()
