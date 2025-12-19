extends Node2D

func load_particle(particle_name : String) :
	return load("res://Scenes/Particles/" + particle_name + ".tscn").instantiate()
