extends Node2D
func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_M:        
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		if Bgmusic.stream_paused: 
			Bgmusic.stream_paused = false 
