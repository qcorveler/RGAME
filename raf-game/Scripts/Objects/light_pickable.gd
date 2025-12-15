extends Pickable

@export var light_increase := 1.0 

func apply_effect(player):
	if "increase_light" in player:
		player.increase_light(light_increase)
		light_increase = 0
