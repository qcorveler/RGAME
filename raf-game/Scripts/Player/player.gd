extends CharacterBody2D

@export var gravity := 1600
@export var speed := 200
@export var jump_velocity := -700.0

@export var run_multiplier := 2.0
@export var crouch_jump_boost := -500
@export var max_crouch_time := 3.0

@export var acceleration = 0.1

@onready var skin = $Skin
@onready var collisionBox : CollisionShape2D = $CollisionShape2D

var states = {}
var current_state: State

var is_running := false
var is_crouching := false
var crouch_timer := 0.0

func _ready() -> void:
	# Charger les états
	states = {
		"idle": $States/Idle,
		"run": $States/Run,
		"jump": $States/Jump,
		"crouch": $States/Crouch
	}

	for state in states.values():
		state.player = self
		
	change_state("idle")

func change_state(new_state_name: String):
	if current_state:
		current_state.exit()
	current_state = states[new_state_name]
	current_state.enter(null)

func _physics_process(delta) :
	
	# Gravité
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, 1600)
	if current_state and !GameState.dialogue_active :
		current_state.physics_update(delta)
	move_and_slide()

func _process(delta):
	if current_state:
		current_state.update(delta)

func play_animation(anim):
	skin.play_anim(anim)

func change_skin(skin_name: String):
	if skin:
		skin.queue_free()

	var new_skin = load("res://Scenes/Personnages/Player/Skins/%s.tscn" % skin_name).instantiate()
	add_child(new_skin)
	new_skin.name = "Skin"
	skin = new_skin

func set_skin_scale(skinScale):
	skin.apply_scale(Vector2(skinScale, skinScale))
	collisionBox.apply_scale(Vector2(skinScale, skinScale))

func get_skin_size():
	return skin.get_skin_size()
	
