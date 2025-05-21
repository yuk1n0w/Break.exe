extends Node


@export var entry_pos: String = ""

func player_ready(player: Node):
	print(entry_pos, get_node(entry_pos))
	if get_node(entry_pos):
		%Player.Position = get_node(entry_pos).Position
