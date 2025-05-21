extends Area2D

@export var next_scene: PackedScene;
@export var entry_pos: String;

func _on_body_entered(body: Node2D) -> void:
	print(%Player, next_scene)
	print("Player entered")
	if body == %Player and next_scene:
			print("Yes")
			Global.entry_pos = entry_pos
			get_tree().change_scene_to_packed(next_scene)
