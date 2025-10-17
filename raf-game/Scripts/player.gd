extends CharacterBody2D

@export var gravity = 1500
@export var speed = 50 #500
@export var jump_velocity = 0 #-1000

@export var acceleration = 0.2

@onready var skin = $SkinRobeDeChambre

func _physics_process(delta) :
	if !is_on_floor() :
		velocity.y = clamp(velocity.y + gravity*delta, -500, 500)
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction !=0 :
		skin.set_direction(direction == -1)
	
	velocity.x = lerp(velocity.x, direction*speed, acceleration)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		change_skin("skin_ehpad")
	
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

	var new_skin = load("res://Scenes/Personnages/Skins/%s.tscn" % skin_name).instantiate()
	add_child(new_skin)
	new_skin.name = "Skin"
	skin = new_skin
