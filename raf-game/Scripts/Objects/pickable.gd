class_name Pickable
extends Area2D

@export var hover_height := 4.0
@export var hover_speed := 2.0
@export var pickup_sound: AudioStream


var start_y := 0.0
var direction := 1

func _ready():
	start_y = position.y
	connect("body_entered", _on_body_entered)

func _process(delta):
	# Effet de flottement
	position.y = start_y + sin(Time.get_unix_time_from_system() * hover_speed) * hover_height

func _on_body_entered(body):
	if not body.is_in_group("Player"):
		return

	apply_effect(body)
	play_sound()
	destroy()

# TO OVERRIDE
func apply_effect(player):
	pass

func play_sound():
	# TODO update ça
	if pickup_sound:
		var audio := AudioStreamPlayer2D.new()
		audio.stream = pickup_sound
		get_tree().current_scene.add_child(audio)
		audio.global_position = global_position
		audio.play()
		audio.connect("finished", audio.queue_free)
		
func destroy():
	var tw := create_tween()
	tw.tween_property(self, "scale", Vector2.ZERO, 0.05)
	tw.tween_callback(queue_free)
