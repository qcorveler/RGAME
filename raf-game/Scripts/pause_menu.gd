extends CanvasLayer

var pause = false

func _ready():
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	for child in get_children():
		child.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func pause_unpause():
	pause = !pause
	get_tree().paused = pause
	if pause :
		show()
	else:
		hide()
	
func _input(event):
	if event.is_action_pressed("pause"):
		pause_unpause()


func _on_unpause_btn_pressed() -> void:
	pause_unpause()


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
