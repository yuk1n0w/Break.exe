extends Node


@export var entry_pos: String = ""

func player_ready(player: Node):
	if get_tree().current_scene.get_node(entry_pos):
		print(get_tree().current_scene.get_node(entry_pos).position)
		player.position = get_tree().current_scene.get_node(entry_pos).position
