extends CharacterBody2D

@export var gravity := 1600
@export var speed := 200 #500
@export var jump_velocity := -700.0
@export var run_multiplier := 2.0
@export var crouch_jump_boost := -500
@export var max_crouch_time := 3.0

@export var acceleration = 0.2

@onready var skin = $Skin
@onready var collisionBox : CollisionShape2D = $CollisionShape2D

var is_running := false
var is_crouching := false
var crouch_timer := 0.0

func _physics_process(delta) :
	# Gestion de la gravité
	if !is_on_floor() :
		velocity.y = velocity.y + gravity*delta
		velocity.y = min(velocity.y, 1500)

	var direction
	
	if !GameState.dialogue_active :
		# Gestion du déplacement 
		direction = Input.get_axis("move_left", "move_right")
		var move_speed = speed
		# Gestion de la course (CTRL)
		if Input.is_action_pressed("run") and direction != 0 and not is_crouching:
			is_running = true
		else:
			is_running = false
		
		if is_running:
			move_speed *= run_multiplier
			
		# Accroupissement (SHIFT)
		if Input.is_action_pressed("crouch") and is_on_floor():
			is_crouching = true
			crouch_timer += delta
			crouch_timer = clamp(crouch_timer, 0.0, max_crouch_time)
		else:
			is_crouching = false
			crouch_timer = 0
		
		# Direction du skin
		if direction !=0 :
			skin.set_direction(direction == -1)
		
		# Vitesse x
		velocity.x = lerp(velocity.x, direction*move_speed, acceleration)
		
		# Saut (SPACE)
		if Input.is_action_just_pressed("jump") and is_on_floor():
			var jump_power : float = jump_velocity
			if crouch_timer > 0.2:
				var charge_ratio = crouch_timer / max_crouch_time
				jump_power += crouch_jump_boost * charge_ratio
				crouch_timer = 0.0
			velocity.y = jump_power
		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y *= 0.5  # stoppe la montée plus tôt = saut plus court
	else :
		direction = 0.0
		velocity.x = lerp(velocity.x, direction*speed, acceleration)
			
	update_animation(direction)
	move_and_slide()
	
func update_animation(direction):
	if is_on_floor() :
		if direction == 0 :
			skin.play_anim("idle")
		else :
			skin.play_anim("run")
	else:
		skin.play_anim("jump")
		
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
	
