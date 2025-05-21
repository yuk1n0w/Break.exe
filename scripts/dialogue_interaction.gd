extends Area2D

var player_inside = false
@export var text: String = "Hello, world!"
@export var speed: float = 0.05
@export var sfx: AudioStream = load("res://assets/square_440.wav")
@export var sfx_vol: float = -5.0
@export var sfx_bus: String = "SFX"
@export var picture: Texture2D = load("res://assets/icon.svg")
@export var pitch: float = 1.0
@export var pitch_randomization: float = 0.1

func _on_body_entered(body: Node2D) -> void:
	if body == %Player:
		player_inside = true


func _on_body_exited(body: Node2D) -> void:
	if body == %Player:
		player_inside = false
		

func _input(event):
	if event.is_action_pressed("ui_accept") && player_inside:
		%Player.do_dialogue(text, picture, sfx, speed, sfx_vol, sfx_bus, pitch, pitch_randomization)
