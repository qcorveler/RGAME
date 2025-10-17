extends TextureRect

var timer : float = 0.0
var framerate := 3
var chambre := 0

var image0 := preload("res://Img/Cinematiques/Ehpad chambre -0.png")
var image1 := preload("res://Img/Cinematiques/Ehpad chambre -1.png")


func _physics_process(delta: float) -> void:
	timer += delta
	if timer >= 1.0/framerate :
		move_img()
		timer = 0
		

func move_img():
	if chambre == 0 :
		texture = image0
	elif chambre == 1 :
		texture = image1
	chambre = (chambre+1)%2
	
