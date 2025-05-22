extends Area2D

@export var next_scene_path: String;
@export var entry_pos: String;

func _on_body_entered(body: Node2D) -> void:
	if body == %Player:
			print("Yes")
			Global.entry_pos = entry_pos
			get_tree().change_scene_to_file(next_scene_path)
