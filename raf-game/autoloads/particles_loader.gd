extends Node2D

func load_particle(name) :
	return load("res://Scenes/Particles/" + name + ".tscn").instantiate()
