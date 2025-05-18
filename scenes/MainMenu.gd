extends Control

# References to the HBoxContainers for each option
@onready var play_option: HBoxContainer = $OptionsVBox/PlayOption
@onready var settings_option: HBoxContainer = $OptionsVBox/SettingsOption
@onready var credits_option: HBoxContainer = $OptionsVBox/CreditsOption
@onready var exit_option: HBoxContainer = $OptionsVBox/ExitOption

# Store all option HBoxContainers in an array for easy iteration
var menu_options: Array[HBoxContainer]
var current_selection_index: int = 0

# Define what your arrow and empty space will look like
# For the video's style, a triangle ">" or "▶" might be good if your font supports it
const ARROW_TEXT = "▶ " # Or "▶ " if your font has a good triangle
const EMPTY_ARROW_TEXT = "  " # Ensure this has the same visual width as ARROW_TEXT

func _ready():
	# Populate the menu_options array
	# Ensure the order here matches the visual order of your options
	menu_options = [
		play_option,
		settings_option,
		credits_option,
		exit_option
	]

	# Ensure only the default option is selected visually at start
	update_visual_selection()

	# Make sure the menu can receive input.
	grab_focus()


func _input(event: InputEvent):
	if not is_visible_in_tree(): # Don't process input if menu is hidden
		return

	var previous_selection = current_selection_index

	if event.is_action_pressed("ui_down"):
		current_selection_index = (current_selection_index + 1) % menu_options.size()
		accept_event() # Consume the event
	elif event.is_action_pressed("ui_up"):
		current_selection_index = (current_selection_index - 1 + menu_options.size()) % menu_options.size()
		accept_event() # Consume the event
	elif event.is_action_pressed("ui_accept"): # Enter or Space by default
		_on_option_selected()
		accept_event() # Consume the event

	if previous_selection != current_selection_index:
		update_visual_selection()
		# Sound playing line was here, now removed


func update_visual_selection():
	for i in range(menu_options.size()):
		var option_hbox: HBoxContainer = menu_options[i]
		# The first child of the HBoxContainer is the Arrow Label
		var arrow_label: Label = option_hbox.get_child(0) as Label
		# The second child is the Text Label (optional, if you want to change its style)
		# var text_label: Label = option_hbox.get_child(1) as Label

		if arrow_label: # Check if the node exists
			if i == current_selection_index:
				arrow_label.text = ARROW_TEXT
				# Optional: Highlight selected text differently, e.g., by changing modulate
				# if text_label: text_label.modulate = Color.YELLOW 
			else:
				arrow_label.text = EMPTY_ARROW_TEXT
				# Optional: Reset non-selected text color
				# if text_label: text_label.modulate = Color.WHITE
		else:
			printerr("ArrowLabel not found for option at index: ", i, " (Node: ", option_hbox.name, ")")
			printerr("Check node paths and ensure Arrow labels are the first child of their HBoxContainers.")


func _on_option_selected():
	# Sound playing line was here, now removed
	# If you still want a slight delay before action, you can keep this:
	# await get_tree().create_timer(0.05).timeout # Optional very small delay for visual feedback

	match current_selection_index:
		0: # Play
			print("Play selected")
			# Example: Transition to your game scene
			# get_tree().change_scene_to_file("res://your_game_scene.tscn")
		1: # Settings
			print("Settings selected")
			# Example: Transition to a settings scene or show a settings panel
			# get_tree().change_scene_to_file("res://settings_menu.tscn")
		2: # Credits
			print("Credits selected")
			# Example: Transition to a credits scene
			# get_tree().change_scene_to_file("res://credits_scene.tscn")
		3: # Exit
			print("Exit selected")
			get_tree().quit() # Quits the game

# play_sfx function was here, now removed
