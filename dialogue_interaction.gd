extends Area2D

var player_inside = false

func _on_body_entered(body: Node2D) -> void:
	if body == %Player:
		player_inside = true


func _on_body_exited(body: Node2D) -> void:
	if body == %Player:
		player_inside = false
		

func _input(event):
	if event.is_action_pressed("ui_accept") && player_inside:
		%Player.do_dialogue("Hello")
