extends Area2D

@export var next_scene: PackedScene;

func _on_area_entered(area: Area2D) -> void:
	if area == %Player and next_scene:
			get_tree().change_scene_to_packed(next_scene)
