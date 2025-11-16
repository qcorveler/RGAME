extends TileMapLayer

@export var player_path : NodePath

@onready var player = get_node(player_path)

var signs_info := {
	Vector2i(41, 5): "RunSign",
	Vector2i(40, -4): "JumpSign",
	Vector2i(28, -14): "ComboSign",
}
