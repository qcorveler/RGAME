extends Pickable

@export var coin_value := 1 

func apply_effect(player):
	if "increase_coins" in player:
		player.increase_coins(coin_value)
		coin_value = 0
