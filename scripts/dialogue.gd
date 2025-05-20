extends Control
@onready var text_sound: AudioStreamPlayer = $TextSound
@onready var label: Label = $Panel/HBoxContainer/Label
@onready var texture_rect: TextureRect = $Panel/HBoxContainer/TextureRect
@onready var timer: Timer = $Timer

func wait_for_action(action_name: String) -> void:
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed(action_name):
			break

func do_dialogue(text, picture=null, sfx=null, speed=null, sfx_vol=null, pitch=null, pitch_randomization=null):
	# Optional parameters - must not be null
	if picture == null: picture = load("res://assets/icon.svg")
	if sfx == null: sfx = load("res://assets/square_440.wav")
	if speed == null: speed = 0.05
	if sfx_vol == null: sfx_vol = -5.0
	if pitch == null: pitch = 1.0
	if pitch_randomization == null: pitch_randomization = 0.1
	
	text_sound.volume_db = sfx_vol
	text_sound.stream = sfx
	texture_rect.texture = picture
	timer.wait_time = speed
	label.text = ""
	
	for letter in text:
		timer.start()
		await timer.timeout
		
		text_sound.pitch_scale = pitch + (randf() - 0.5) * pitch_randomization
		text_sound.play()
		label.text += letter
		
		
		if Input.is_action_pressed("ui_cancel"):
			label.text = text
			break
			
	await wait_for_action("ui_accept")
		
func run_list(dialogue_list):
	for entry in dialogue_list:
		if entry["type"] == "question":
			pass
		else:
			await do_dialogue(entry["text"], entry["picture"], entry["sfx"], entry["speed"], entry["sfx_vol"])
