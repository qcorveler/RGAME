extends CanvasLayer

@export var switch_duration : float = 1.0
var current_scene : String = ''

func _init():
	current_scene = "intro_scene"
	
func _ready():
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$ColorRect.modulate.a = 0

func go_to_scene(scene: String):
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(
		$ColorRect, 'modulate:a', 1, switch_duration / 2.0
	)
	await tween.finished
	
	get_tree().change_scene_to_file('res://Scenes/%s.tscn' % scene)
	get_tree().paused = false
	current_scene = scene
	
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(
		$ColorRect, 'modulate:a', 0, switch_duration / 2.0
	)
	await tween.finished
	
	
