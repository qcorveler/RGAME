extends CharacterBody2D

@export var speed := 200.0
@export var rotation_speed = 0.1
@export var wait_time := 0.01
@export var loop := true
@export var change_rotation_direction := false

@onready var waypoints := $"../WayPoints".get_children()
@onready var sprite := $Sprite2D

var current_index := 0
var waiting := false

func _physics_process(delta):
	if waypoints.is_empty() or waiting:
		return

	var target = waypoints[current_index].global_position
	var dir = (target - global_position)

	if dir.length() < 2:
		arrive_at_point()
		return
	var rotation_factor = -1 if change_rotation_direction else 1
	sprite.rotate(rotation_factor * rotation_speed)
	velocity = dir.normalized() * speed
	move_and_slide()

func arrive_at_point():
	velocity = Vector2.ZERO
	waiting = true

	await get_tree().create_timer(wait_time).timeout

	current_index += 1
	if current_index >= waypoints.size():
		current_index = 0 if loop else waypoints.size() - 1

	waiting = false
