extends Control

@onready var play_option_hbox: HBoxContainer = $OptionsVBox/PlayOption
@onready var settings_option_hbox: HBoxContainer = $OptionsVBox/SettingsOption
@onready var credits_option_hbox: HBoxContainer = $OptionsVBox/CreditsOption
@onready var exit_option_hbox: HBoxContainer = $OptionsVBox/ExitOption
@onready var arrow_label: Label = $ArrowLabel # Assumes ArrowLabel is direct child of MainMenu

@onready var options_vbox: VBoxContainer = $OptionsVBox

# No MENU_MUSIC_PATH constant needed if relying on AudioStreamPlayer's stream & autoplay

var menu_option_nodes: Array[HBoxContainer]
var current_selection_index: int = 0
var current_tween: Tween

const ARROW_ANIMATION_DURATION = 0.12
const ARROW_TEXT = "▶ "

func _ready():
	menu_option_nodes = [
		play_option_hbox,
		settings_option_hbox,
		credits_option_hbox,
		exit_option_hbox
	]
	
	if not is_instance_valid(arrow_label):
		printerr("MainMenu: ArrowLabel node not found or invalid! Path: $ArrowLabel.")
		return

	self.focus_mode = Control.FOCUS_ALL

	await get_tree().process_frame
	set_arrow_initial_position()

	# --- Music Handling: Resume if paused, ensure it's playing ---
	if Engine.has_singleton("MusicPlayer"):
		var music_player_node = Engine.get_singleton("MusicPlayer") as AudioStreamPlayer
		if is_instance_valid(music_player_node):
			# If it was paused (e.g., returning from game), unpause it
			if music_player_node.stream_paused:
				music_player_node.stream_paused = false
				print("MainMenu: MusicPlayer unpaused.")
			
			# If for some reason it's not playing (e.g., first launch and autoplay handled it,
			# or it was stopped entirely instead of paused), ensure it plays.
			# This is a fallback, autoplay should handle initial play.
			if not music_player_node.playing and is_instance_valid(music_player_node.stream):
				music_player_node.play()
				print("MainMenu: MusicPlayer (re)started (was not playing).")
			elif not is_instance_valid(music_player_node.stream):
				printerr("MainMenu: MusicPlayer has no stream assigned to play.")


			# Optional: Apply volume from settings
			if Engine.has_singleton("Settings"):
				var settings_node = Engine.get_singleton("Settings")
				# Check if the method exists to prevent errors if Settings.gd changes
				if settings_node.has_method("get_master_volume_percent"):
					var volume_percent = settings_node.get_master_volume_percent() / 100.0
					if volume_percent <= 0.001: music_player_node.volume_db = -80.0
					else: music_player_node.volume_db = linear_to_db(volume_percent)
				else:
					printerr("MainMenu: Settings autoload found, but 'get_master_volume_percent' method missing.")
			# else:
				# printerr("MainMenu: Settings autoload not found (for volume).") # Optional print
		else:
			printerr("MainMenu: MusicPlayer singleton found but is not a valid AudioStreamPlayer instance.")
	else:
		printerr("MainMenu: MusicPlayer autoload not found! Music will not play or resume.")
	# --- End Music ---

	grab_focus()

func set_arrow_initial_position():
	if menu_option_nodes.is_empty() or not is_instance_valid(arrow_label) or not is_instance_valid(options_vbox):
		printerr("MainMenu: Cannot set arrow initial position: critical nodes invalid.")
		return

	var target_node = menu_option_nodes[current_selection_index]
	if not is_instance_valid(target_node):
		printerr("MainMenu: Initial target node for arrow is invalid.")
		return

	var desired_arrow_x_global = arrow_label.global_position.x
	var target_y_global_centered = target_node.global_position.y + (target_node.size.y / 2.0) - (arrow_label.size.y / 2.0)

	arrow_label.global_position = Vector2(desired_arrow_x_global, target_y_global_centered)
	arrow_label.text = ARROW_TEXT

func _input(event: InputEvent):
	if not is_visible_in_tree():
		return

	var previous_selection = current_selection_index

	if event.is_action_pressed("ui_down"):
		current_selection_index = (current_selection_index + 1) % menu_option_nodes.size()
		accept_event()
	elif event.is_action_pressed("ui_up"):
		current_selection_index = (current_selection_index - 1 + menu_option_nodes.size()) % menu_option_nodes.size()
		accept_event()
	elif event.is_action_pressed("ui_accept"):
		_on_option_selected()
		accept_event()

	if previous_selection != current_selection_index:
		if is_instance_valid(arrow_label):
			animate_arrow_to_selection()
		else:
			printerr("MainMenu: ArrowLabel became invalid, cannot animate.")


func animate_arrow_to_selection():
	if menu_option_nodes.is_empty() or not is_instance_valid(arrow_label):
		printerr("MainMenu: Cannot animate arrow: menu_option_nodes is empty or arrow_label is invalid.")
		return

	var target_node = menu_option_nodes[current_selection_index]
	if not is_instance_valid(target_node):
		printerr("MainMenu: Target node for arrow animation is invalid.")
		return

	var final_y_global_centered = target_node.global_position.y + (target_node.size.y / 2.0) - (arrow_label.size.y / 2.0)
	var _final_x_global = arrow_label.global_position.x 

	if is_instance_valid(current_tween) and current_tween.is_running():
		current_tween.kill()

	current_tween = create_tween()
	current_tween.set_trans(Tween.TRANS_QUAD)
	current_tween.set_ease(Tween.EASE_OUT)
	current_tween.tween_property(arrow_label, "global_position:y", final_y_global_centered, ARROW_ANIMATION_DURATION)

func _on_option_selected():
	match current_selection_index:
		0: # Play
			print("Play selected")
			if Engine.has_singleton("MusicPlayer"):
				var music_player_node = Engine.get_singleton("MusicPlayer") as AudioStreamPlayer
				if is_instance_valid(music_player_node) and music_player_node.playing:
					music_player_node.stream_paused = true # Pause music
					print("MainMenu: MusicPlayer paused for game scene.")
			else:
				printerr("MainMenu: MusicPlayer autoload not found when trying to pause for game scene.")
			get_tree().change_scene_to_file("res://scenes/character_test_scene.tscn")
		1: # Settings
			print("Settings selected")
			# Music continues playing (stream_paused remains false)
			get_tree().change_scene_to_file("res://scenes/settings.tscn")
		2: # Credits
			print("Credits selected")
			# Music continues playing
			# get_tree().change_scene_to_file("res://credits_scene.tscn")
		3: # Exit
			print("Exit selected")
			get_tree().quit()
