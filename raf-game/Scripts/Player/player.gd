extends CharacterBody2D

@export var gravity := 1600
@export var speed := 200
@export var jump_velocity := -700.0

@export var run_multiplier := 2.0
@export var crouch_jump_boost := -500
@export var max_crouch_time := 3.0

@export var acceleration = 0.1

@onready var skin = $Skin
@onready var collisionStanding : CollisionShape2D = $CollisionStanding
@onready var collisionCrouching : CollisionShape2D = $CollisionCrouching

var states = {}
var current_state: State

var is_running := false
var is_crouching := false
var crouch_timer := 0.0

func _ready() -> void:
	# Gestion de la hitbox
	set_hitbox_crouching(false)
	
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
	if GameState.dialogue_active : # On ne peut pas changer d'état quand le dialogue est actif
		return
	if current_state:
		current_state.exit()
	current_state = states[new_state_name]
	current_state.enter(null)

func _physics_process(delta) :
	
	# Gravité
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, 1600)
	if current_state :
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
	collisionStanding.apply_scale(Vector2(skinScale, skinScale))
	collisionCrouching.apply_scale(Vector2(skinScale, skinScale))

func get_skin_size():
	return skin.get_skin_size()

func set_hitbox_crouching(value : bool):
	collisionCrouching.disabled = !value
	collisionStanding.disabled = value

func try_stand_up_smooth():
	if not is_crouching:
		return  # déjà debout

	var target_pos = find_free_stand_position()
	if target_pos == global_position:
		return

	# On tweene la position jusqu'à la zone libre
	var tween := create_tween()
	tween.tween_property(self, "global_position", target_pos, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	# On attend la fin du tween avant de se relever pour éviter un pop visuel
	tween.finished.connect(_on_stand_up_tween_finished)
	
func _on_stand_up_tween_finished():
	# Activer la hitbox debout
	is_crouching = false
	set_hitbox_crouching(false)

	# Choisir l'état après relevage
	if Input.is_action_pressed("jump"):
		change_state("jump")
	else:
		change_state("idle")

func find_free_stand_position() -> Vector2:
	var shape = collisionStanding.shape
	var max_slide := 100.0
	var step := 2.0

	# Test à la position actuelle
	if not test_collision_at(global_position, shape):
		return global_position

	# Sinon, glisser à gauche/droite jusqu'à trouver un endroit libre
	for offset in range(int(step), int(max_slide) + 1, int(step)):
		var right := global_position + Vector2(offset, 0)
		var left := global_position - Vector2(offset, 0)

		if not test_collision_at(right, shape):
			return right
		if not test_collision_at(left, shape):
			return left
	return global_position
	
func test_collision_at(global_pos: Vector2, shape) -> bool:
	var space := get_world_2d().direct_space_state
	
	var params := PhysicsShapeQueryParameters2D.new()
	params.shape = shape
	params.transform = Transform2D(0, global_pos)
	params.margin = 0.01
	params.exclude = [self]  # on ignore le joueur
	params.collision_mask = 0xFFFFFFFF & ~(1 << 4) # ⚠ Ignore la couche 5 (qui correspond aux panneaux d'information)
	
	var result := space.intersect_shape(params, 32)
	return result.size() > 0
